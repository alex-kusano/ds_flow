require 'engine/dispatcher'
require 'flow/flow_instance'
require 'transient/envelope_information'

class FlowHandler
  
  @@instance = FlowHandler.new
  
  def self.instance
    @@instance
  end
  
  def envelope_sent( envelope_info )
    
    envelope_id = envelope_info.envelope_id
    code = envelope_info.get_envelope_param( "AutomationCode" )
    
    unless code.nil?
      
      flow_instance = Flow::FlowInstance.where( code: code, envelope_id: envelope_id ).first_or_create
            
      agents = envelope_info.get_recipients( type: 'Agent', status: ['Sent', 'Delivered'] )
      
      #Only one is actually expected
      agents.each do |agent|         
        handle_agent_automation( flow_instance, agent, envelope_info )
      end
      
    end
    
    @result
  end
  
  def envelope_signed( envelope_info )
    
    envelope_id = envelope_info.envelope_id
    code = envelope_info.get_envelope_param( "AutomationCode" )
    
    unless code.nil?
      
      flow_instance = Flow::FlowInstance.where( code: code, envelope_id: envelope_id ).first_or_create
      
      pending_candidates = get_pending_candidates( flow_instance )      
      routing_order = handle_signers_automation( pending_candidates.to_a, envelope_info )      
      
      if validate_rule_sets( flow_instance, routing_order )
        purge_pending_candidates( flow_instance, pending_candidates )
      end
    end
    
     @result    
  end
  
  
  def handle_agent_automation( flow_instance, agent, envelope_info )
    
    company = Company.find_by( name: agent.contact.name )
    
    unless company.nil?
      routing_order = agent.routing_order
      candidates = retrieve_candidates( company, flow_instance, agent.routing_order )
      
      dispatcher = Dispatcher.new 
      
      @result = dispatcher.add_candidates( flow_instance.envelope_id, candidates )
      dispatcher.delete_recipients( flow_instance.envelope_id, [agent] )
    end
    
  end
  
  def handle_signers_automation( pending_candidates, envelope_info ) 
    
    recipient_ids = pending_candidates.collect do |candidate|
      candidate.recipient_id
    end
    
    routing_order = 0
    
    signers = envelope_info.get_recipients( type: 'Signer', status: 'Completed', orig_id: recipient_ids )
    
    signers.each do |signer|      

      index = pending_candidates.find_index do |candidate| 
        signer.get_param('orig_id') == candidate.recipient_id
      end
      
      candidate = pending_candidates[index]
      candidate.sign_date = signer.sign_date
      candidate.save
     
      routing_order = candidate.routing_order > routing_order ? candidate.routing_order : routing_order
    end
    
    routing_order
  end
  
  def retrieve_candidates( company, flow_instance, routing_order )
    
    role_ids = RuleSet.get_associated_role_ids( flow_instance.code, routing_order )    
    employments = Employment.where( company: company, role_id: role_ids).joins( :contact, :role ).includes( :contact, :role )
    
    candidates = employments.collect do |employment|
      { employment: employment, routing_order: routing_order, recipient_id: UUIDTools::UUID.random_create.to_s }
    end
    
    flow_instance.candidates.create( candidates )
  end
  
  def get_pending_candidates( flow_instance )
    
    pending_candidates = Flow::Candidate.where( flow_instance: flow_instance, sign_date: nil )
    
  end
  
  def validate_rule_sets( flow_instance, routing_order )
    
    completed_count = get_complete_candidates_count( flow_instance, routing_order)
    rule_sets = RuleSet.get_rule_sets( flow_instance.code, routing_order )
    
    rule_sets.each do |rule_set|
      return true if rule_set.validate_rule_set( completed_count )
    end
    
    return false
  end
  
  def get_complete_candidates_count( flow_instance, routing_order )
    Employment.joins("INNER JOIN flow_candidates ON flow_candidates.employment_id = employments.id").where("flow_candidates.flow_instance_id=? AND flow_candidates.routing_order=? AND flow_candidates.sign_date IS NOT NULL", flow_instance.id, routing_order ).group(:role_id).count
  end
  
  def purge_pending_candidates( flow_instance, candidates )
    
    pending_candidates = candidates.select do |candidate|
      candidate.sign_date.nil?
    end
    
    dispatcher = Dispatcher.new 
    
    @result = dispatcher.delete_recipients( flow_instance.envelope_id, pending_candidates )
    Flow::Candidate.delete( pending_candidates )
  end
end