require 'transient/envelope_information'
require 'engine/flow_handler'

class Api::ConnectController < ApplicationController
  
  def sent
    envelope_info = EnvelopeInformation.new ( params[:DocuSignEnvelopeInformation] )
    
    flow_handler = FlowHandler.instance
    flow_handler.envelope_sent( emvelope_info )
    
    render xml: envelope_info
  end
  
  def signed
    
  end
  
end
