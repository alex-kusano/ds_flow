require 'net/http'

class Dispatcher
  
  @@instance = Dispatcher.new
  
  def self.instance
    @@instance
  end
  
  def add_candidates( account_info, envelope_id, candidates = [], sender )
    
    json_list = candidates.collect do |candidate|
      json_new_signer( candidate )
    end
    
    body =   "{"
    body <<    "\"signers\" : ["
    body <<    json_list.join(",")
    body <<    "]"
    body <<  "}"
    
    uri = URI.parse("#{account_info.base_url}/envelopes/#{envelope_id}/recipients")
    
    auth = { token: account_info.token, sobo: sender }
    
    Rails.logger.debug( "POST to #{uri.to_s}" )
    Rails.logger.debug( "######################################" )
    Rails.logger.debug( body )
    Rails.logger.debug( "######################################" )
    
    Net::HTTP.start( uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Post.new( uri, get_headers(auth) )

      response = http.request( request, body ) # Net::HTTPResponse object
      response.body
    end
  end
  
  def delete_recipients( account_info, envelope_id, recipients = [], sender )
    
    agents = json_del_list_by_type( recipients, 'Agent')
    signers = json_del_list_by_type( recipients, 'Signer' )
    
    body =   "{"
    body <<    "\"agents\" : ["
    body <<      agents.join(",")
    body <<    "],"
    body <<    "\"signers\" : ["
    body <<      signers.join(",")
    body <<    "]"
    body <<  "}"
    
    uri = URI.parse("#{account_info.base_url}/envelopes/#{envelope_id}/recipients")
    
    auth = { token: account_info.token, sobo: sender }
    
    Rails.logger.debug( "DELETE to #{uri.to_s}" )
    Rails.logger.debug( "######################################" )
    Rails.logger.debug( body )
    Rails.logger.debug( "######################################" )
    
    Net::HTTP.start( uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Delete.new( uri, get_headers(auth) )

      response = http.request( request, body ) # Net::HTTPResponse object
      response.body
    end  
  end
  
  def create_connect_config( account_info, name, publish_url, recipient_events, envelope_events = [] ) 
    
    
    body =  "{"
    body <<    "\"name\" : \"#{name}\","
    body <<    "\"allUsers\" : \"true\","
    body <<    "\"allowEnvelopePublish\" : \"true\","
    body <<    "\"enableLog\" : \"true\","
    body <<    "\"includeDocuments\" : \"false\","
    body <<    "\"includeSenderAccountasCustomField\" : \"true\","
    body <<    "\"recipientEvents\" : \"#{recipient_events.join(",")}\","
    body <<    "\"envelopeEvents\" : \"#{envelope_events.join(",")}\","    
    body <<    "\"urlToPublishTo\" : \"#{publish_url}\""    
    body << "}"
  
    auth = { token: account_info.token }
    uri = URI.parse("#{account_info.base_url}/connect")
  
    Rails.logger.debug( "POST to #{uri.to_s}" )
    Rails.logger.debug( "######################################" )
    Rails.logger.debug( body )
    Rails.logger.debug( "######################################" )
  
    Net::HTTP.start( uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Post.new( uri, get_headers( auth ) )

      response = http.request( request, body ) # Net::HTTPResponse object
      
      if response.is_a? Net::HTTPSuccess
        return JSON.parse( response.body )
      else
        return nil
      end
    end      
  end

  def delete_connect_config( account_info, connect_id ) 
      
    body = ""
    
    uri = URI.parse("#{account_info.base_url}/connect/#{connect_id}")
    
    auth = { token: account_info.token }
    
    Rails.logger.debug( "DELETE to #{uri.to_s}" )
    Rails.logger.debug( "######################################" )
    Rails.logger.debug( body )
    Rails.logger.debug( "######################################" )
  
    Net::HTTP.start( uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Delete.new( uri, get_headers(auth) )
  
      response = http.request( request, body ) # Net::HTTPResponse object
      if response.is_a? Net::HTTPSuccess
        return response.message
      else
        return nil
      end
    end  
  end

  def update_connect_users( account_info, connect_id, user_ids ) 
    
    body =  "{"
    body <<    "\"connectId:\" : \"#{connect_id}\","
    body <<    "\"userIds:\" : \"#{user_ids.join(",")}\""
    body << "}"
  
    auth = { token: account_info.token }
    uri = URI.parse("#{account_info.base_url}/connect")

    Rails.logger.debug( "POST to #{uri.to_s}" )
    Rails.logger.debug( "######################################" )
    Rails.logger.debug( body )
    Rails.logger.debug( "######################################" )

    Net::HTTP.start( uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Put.new( uri, get_headers(auth) )

      response = http.request( request, body ) # Net::HTTPResponse object
      
      if response.is_a? Net::HTTPSuccess
        return JSON.parse( response.body )
      else
        return nil
      end
    end      
  end
  
  def create_token( email, password, integrator_key, server = "demo.docusign.net", version = "v2" )
    uri = URI.parse("https://#{server}/restapi/#{version}/oauth2/token")
    
    Rails.logger.debug( "Form POST to #{uri.to_s}" )
    response = Net::HTTP.post_form(uri, "grant_type" => "password",
                                        "client_id" => integrator_key,
                                        "username" => email,
                                        "password" => password,
                                        "scope" => "api" )
    unless response.is_a? Net::HTTPSuccess
      return nil
    end
    
    body = JSON.parse( response.body )
    body['access_token']
  end

  def delete_token( ds_account, server = "demo.docusign.net", version = "v2" )
    uri = URI.parse("https://#{server}/restapi/#{version}/oauth2/revoke")
    
    Rails.logger.debug( "Form POST to #{uri.to_s}" )
    response = Net::HTTP.post_form(uri, "token" => "#{ds_account.token}" )
    
    return response.is_a? Net::HTTPSuccess
  end
  
  def login_information email, password, integrator_key, server = "demo.docusign.net", version = "v2" 
    uri = URI.parse("https://#{server}/restapi/#{version}/login_information?api_password=true")
    
    headers = get_headers( email: email, password: password, integrator_key: integrator_key )
    
    Rails.logger.debug( "GET to #{uri.to_s}" )
    Net::HTTP.start( uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new( uri, headers )
      response = http.request( request ) # Net::HTTPResponse object
      
      if response.is_a? Net::HTTPSuccess
        return JSON.parse( response.body )
      else
        return nil
      end
    end 
  end
    
  def get_headers auth_params = {}
   
    headers =  {}
    headers["Content-Type"] = "application/json"
    headers["Accept"]       = "application/json"

    token = auth_params[:token]    
    if token.nil?
      headers["X-DocuSign-Authentication"] = authentication_string( auth_params )      
    else
      headers["Authorization"]  = "bearer #{token}"
      sobo = auth_params[:sobo] 
      unless sobo.nil?
        headers["X-DocuSign-Act-As-User"]  = "#{sobo}"
      end
    end
    
    headers
  end
  
  
  ###################################################################
  private
  ###################################################################
  
  def json_new_signer( recipient ) 
    json =   "{"
    json <<    "\"email\" : \"#{recipient.contact.email}\"," 
    json <<    "\"name\" : \"#{recipient.contact.name}\","
    json <<    "\"routingOrder\" : \"#{recipient.flow_instance.routing_order+1}\","
    json <<    "\"recipientId\" : \"#{recipient.recipient_id}\","
    json <<    "\"customFields\" : [\"orig_id:#{recipient.recipient_id}\"]"
    json <<  "}"
  end
  
  def json_del_list_by_type( recipient_list, type )
    
    filtered_list = recipient_list.select do |recipient| 
      recipient.type == type
    end
    
    json_list = filtered_list.collect do |recipient|
      json_del( recipient )
    end
    
    return json_list
  end

  def json_del( recipient )
    json =  "{"
    json <<    "\"recipientId\" : \"#{recipient.recipient_id}\""    
    json << "}"
  end

  def authentication_string login_params
    sobo = login_params[:sobo] 
    auth =  "{"
    auth <<    "\"Username\":\"#{login_params[:email]}\","
    unless sobo.nil?
      auth <<  "\"SendOnBehalfOf\":\"#{sobo}\","
    end
    auth <<    "\"Password\":\"#{login_params[:password]}\","
    auth <<    "\"IntegratorKey\":\"#{login_params[:integrator_key]}\""
    auth << "}"
  end

end

  