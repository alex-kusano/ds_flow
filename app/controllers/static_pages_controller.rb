class StaticPagesController < ApplicationController
  def home 
    rip = request.remote_ip
    
    render json: rip
  end
end
