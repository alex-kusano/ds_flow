require 'engine/dispatcher'

class AccountHandler
  
  @@instance = AccountHandler.new
  
  def self.instance
    @@instance
  end
  
  def login( email, password, integrator_key )
        
    response = Dispatcher.instance.login_information( email, password, integrator_key )
    
    return nil if response.nil?
    
    login_info = {}        
    login_accounts = response["loginAccounts"]

    index = login_accounts.find_index do |login| 
      login["isDefault"] == "true"
    end

    login_info[:user_name] = login_accounts[index]["userName"]
    login_info[:email] = login_accounts[index]["email"]
    login_info[:account_id] = login_accounts[index]["accountId"]
    login_info[:base_url] = login_accounts[index]["baseUrl"]
    login_info[:user_id] = login_accounts[index]["userId"]
    login_info[:api_pass] = response["apiPassword"]
    login_info[:integrator_key] = integrator_key

    return login_info
  end
  
  def register( login_info ) 
    
    account = DsAccount.find_by( external_id: login_info[:account_id] )
    
    return nil unless account.nil? 
    
    token = Dispatcher.instance.create_token( login_info[:user_id], login_info[:api_pass], login_info[:integrator_key] )
    
    account = DsAccount.new( username: login_info[:user_name], 
                             email: login_info[:email],
                             token: token,
                             external_id: login_info[:account_id],
                             base_url: login_info[:base_url],
                             user_id: login_info[:user_id] )
    account.save
    
    return account   
  end
  
  def update_connect_config( account, event_handler_path = "https://dsflow.herokuapp.com/api/connect" )
    
    config = ConnectConfig.find_by( account_id: account.external_id )
    
    if config.nil?       
      csend_response = Dispatcher.instance.create_connect_config( account, 
                                                                  "Campari_Send", 
                                                                  "#{event_handler_path}/sent",
                                                                  ["Sent"] )
      
      csign_response = Dispatcher.instance.create_connect_config( account, 
                                                                  "Campari_Sign", 
                                                                  "#{event_handler_path}/signed",
                                                                  ["Declined","Voided"],
                                                                  ["Completed"] )
      
      unless ( csend_response.nil? || csign_response.nil? )
        config = ConnectConfig.new( account_id: account.external_id,
                                    send_interface_id: csend_response['connectId'], 
                                    sign_interface_id: csign_response['connectId'] )
        
        config.save
      end   
    end
    
    config
  end
  
  def disconnect( ds_account ) 
    
    config = ConnectConfig.find_by( account_id: ds_account.external_id )
    
    unless config.nil?
      Dispatcher.instance.delete_connect_config( ds_account, config.send_interface_id )  
      Dispatcher.instance.delete_connect_config( ds_account, config.sign_interface_id )
      config.destroy
    end
    
    Dispatcher.instance.delete_token( ds_account )    
  end
  
end