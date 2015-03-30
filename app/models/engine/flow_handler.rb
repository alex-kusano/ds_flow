require 'transient/envelope_information'
require 'flow/flow_instance'

class FlowHandler
  
  @@instance = FlowHandler.new
  
  def self.instance
    @@instance
  end
  
  def envelope_sent( envelope_info )
    
    envelope_id = envelope_info.envelope_id
    code = envelope_info.get_param( "AutomationCode" )
    
    unless code.nil?
      
      flow_instance = FlowInstance.where( code: code, envelope_id: envelope_id ).first_or_create
      
      agents = envelope_info.get_recipients( type: 'Agent', status: ['Sent', 'Delivered'] )
      
      #Olny one is actually expected
      agents.each do |agent| 
        handle_agent_automation( flow_instance, agent, envelope_info )
      end
      
    end
    
    envelope_id
  end
  
  def handle_agent_automation( flow_instance, agent, envelope_info )
    
    routing_order = agent.routing_order
    
    
    
  end
  
  
  # Stub function for now
  def get_candidates( flow_instance, agent ) 
    
    candidates = []
    if( agent.routing_order = 1 )
      candidates = Contact.where( id: [1,2] )
    else
      candidates = Contact.where( id: [3,4] )
    end
    
    return candidates
  end
  
  
  
end