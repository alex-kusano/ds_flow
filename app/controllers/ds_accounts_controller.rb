require 'engine/account_handler'

class DsAccountsController < ApplicationController
  
  def new     
  end
  
  def create
    
    handler = AccountHandler.instance
    
    login_info = handler.login( params[:email], params[:password], params[:key] )
    if login_info.nil?
      redirect_to accounts_new_path notice: 'Login Failed!'
      return
    end
    
    ds_account = handler.register( login_info )
    if ds_account.nil?
      redirect_to accounts_path notice: 'User is already registered!'
      return
    end
    handler.update_connect_config( ds_account, api_connect_url )
    redirect_to accounts_path, notice: 'User registered successfully.'
  end
  
  def destroy
    ds_account = DsAccount.find(params[:id])
    
    handler = AccountHandler.instance
    
    if handler.disconnect( ds_account )
      ds_account.destroy
      redirect_to accounts_url, notice: 'Account link successfully destroyed' 
      
    else
      redirect_to accounts_url, notice: 'Account link destruction failed'      
    end
  end
  
  def index
    @accounts = DsAccount.page(params[:page]).per(10)
  end
end
