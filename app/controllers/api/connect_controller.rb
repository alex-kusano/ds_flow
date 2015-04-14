require 'transient/envelope_information'
require 'engine/flow_handler'

class Api::ConnectController < ApplicationController
  
  def index
    redirect_to root_path
  end
  
  def sent
    envelope_info = EnvelopeInformation.new ( params[:DocuSignEnvelopeInformation] )
    
    flow_handler = FlowHandler.instance
    result = flow_handler.envelope_sent( envelope_info ) 
    
    render json: result
  end
  
  def signed
    envelope_info = EnvelopeInformation.new ( params[:DocuSignEnvelopeInformation] )
    
    flow_handler = FlowHandler.instance
    result = flow_handler.envelope_signed( envelope_info )
    
    render json: result
  end
  
end
