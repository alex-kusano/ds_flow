require 'engine/dispatcher'
require 'engine/category_matcher'
require 'flow/flow_instance'
require 'transient/envelope_information'

class FlowHandler
  
  @@instance = FlowHandler.new
  
  def self.instance
    @@instance
  end
  
  def envelope_sent( envelope_info )
    
    recipients = envelope_info.recipients
    merged_tabs = {}
    
    recipients.each do |recipient|
      merged_tabs.merge!(recipient.tabs)
    end
    
    agents = envelope_info.get_recipients( type: 'Agent', status: ['Sent', 'Delivered'] )

    #Only one is actually expected
    agents.each do |agent|         
      handle_agent_automation( agent, envelope_info, merged_tabs )
    end
    
    @result
  end
  
  def envelope_signed( envelope_info )
    
    envelope_id = envelope_info.envelope_id
    flow_instances = Flow::FlowInstance.where( envelope_id: envelope_id, complete_date: nil )
    
    flow_instances.each do |flow_instance|
    
      pending_candidates = get_pending_candidates( flow_instance ).to_a
      handle_signers_automation( pending_candidates, envelope_info )      

      if validate_rule_sets( flow_instance )
        purge_pending_candidates( flow_instance, pending_candidates )
        flow_instance.complete_date = DateTime.now
        flow_instance.save
      end
    end 
    
    @result    
  end
  
  
  def handle_agent_automation( agent, envelope_info, tabs )
    
    company = Company.find_by( name: agent.contact.name )
    
    unless company.nil?
      envelope_id = envelope_info.envelope_id
     
      matcher = CategoryMatcher.instance
      code = matcher.get_category_code( company, tabs )
      unless code.nil?
        
        routing_order = agent.routing_order
        flow_instance = Flow::FlowInstance.where( code: code, envelope_id: envelope_id, 
                                                  routing_order: routing_order, company: company ).first_or_create
        
        candidates = retrieve_candidates( flow_instance )

        dispatcher = Dispatcher.instance

        @result = dispatcher.add_candidates( flow_instance.envelope_id, candidates )
        dispatcher.delete_recipients( flow_instance.envelope_id, [agent] )
      end
      
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
    end    
  end
  
  def retrieve_candidates( flow_instance )
    
    role_ids = RuleSet.get_associated_role_ids( flow_instance.code )    
    employments = Employment.where( company: flow_instance.company, role_id: role_ids).joins( :contact ).includes( :contact )
    
    candidates = employments.collect do |employment|
      { employment: employment, recipient_id: UUIDTools::UUID.random_create.to_s }
    end
    
    flow_instance.candidates.create( candidates )
  end
  
  def get_pending_candidates( flow_instance )
    
    pending_candidates = Flow::Candidate.where( flow_instance: flow_instance, sign_date: nil )
    
  end
  
  def validate_rule_sets( flow_instance )
    
    completed_count = get_complete_candidates_count( flow_instance )
    rule_sets = RuleSet.get_rule_sets( flow_instance.code )
    
    rule_sets.each do |rule_set|
      return true if rule_set.validate_rule_set( completed_count )
    end
    
    return false
  end
  
  def get_complete_candidates_count( flow_instance )
    Employment.joins("INNER JOIN flow_candidates ON flow_candidates.employment_id = employments.id").where("flow_candidates.flow_instance_id=? AND flow_candidates.sign_date IS NOT NULL", flow_instance.id ).group(:role_id).count
  end
  
  def purge_pending_candidates( flow_instance, candidates )
    
    pending_candidates = candidates.select do |candidate|
      candidate.sign_date.nil?
    end
    
    dispatcher = Dispatcher.instance
    
    @result = dispatcher.delete_recipients( flow_instance.envelope_id, pending_candidates )
    Flow::Candidate.delete( pending_candidates )
  end
end