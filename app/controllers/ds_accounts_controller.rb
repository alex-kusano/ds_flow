class DsAccountsController < ApplicationController
  
  def register 
    
  end
  
  def index
    @accounts = DsAccount.all
  end
end
