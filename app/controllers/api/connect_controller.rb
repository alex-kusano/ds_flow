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
    status = envelope_info.envelope_status
    
    flow_handler = FlowHandler.instance
    if( status == 'Voided' || status == 'Rejected' )
      result = flow_handler.envelope_cancelled( envelope_info )
    else
      result = flow_handler.envelope_signed( envelope_info )
    end
    
    
    render json: result
  end
  
end
