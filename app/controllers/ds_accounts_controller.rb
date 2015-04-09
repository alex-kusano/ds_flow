require 'engine/account_handler'

class DsAccountsController < ApplicationController
  
  def new 
    
  end
  
  def create
    
    handler = AccountHandler.instance
    
    login_info = handler.login( params[:email], params[:password], params[:key] )
    if login_info.nil?
      redirect_to accounts_register_path notice: 'Login Failed!'
    end
    
    ds_account = handler.register( login_info )
    if ds_account.nil?
      redirect_to accounts_path notice: 'User is already registered!'
    end
    
    handler.update_connect_config( ds_account )
    
    redirect_to accounts_path, notice: 'User registered successfully.'
  end
  
  def destroy
    
  end
  
  def index
    @accounts = DsAccount.all
  end
end
