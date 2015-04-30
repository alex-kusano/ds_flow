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
    
    merged_tabs.merge!(envelope_info.envelope_params)
    
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
        purge_pending_candidates( flow_instance, pending_candidates, envelope_info )
        flow_instance.complete_date = DateTime.now
        flow_instance.save
      end
    end
    
    @result    
  end
  
  def envelope_cancelled( envelope_info )
    envelope_id = envelope_info.envelope_id
    flow_instances = Flow::FlowInstance.where( envelope_id: envelope_id, complete_date: nil )
    
    flow_instances.each do |flow_instance|
    
      pending_candidates = get_pending_candidates( flow_instance )
      pending_candidates.destroy_all 
      flow_instance.complete_date = DateTime.now
      flow_instance.save      
    end
  end
  
  def employment_created( employment )
    
    company = employment.company
    
    flow_instances = Flow::FlowInstance.where( company: company )
    
    flow_instances.each do | flow_instance |
      
      account_info = DsAccount.find_by( external_id: flow_instance.account_id )
      
      candidate = flow_instance.candidates.create( employment: employment, recipient_id: UUIDTools::UUID.random_create.to_s )
      
      Dispatcher.instance.add_candidates( account_info,
                                          flow_instance.envelope_id,
                                          [ candidate ],
                                          flow_instance.sender.email )
      
    end
    
  end

  def employment_updated( employment )
    
    if employment.company_changed? 
      employment_destroyed( employment )
      employment_created( employment )
    end
    
  end
  
  def employment_destroyed( employment )
    
    candindancies = Flow::Candidate.where( employment: employment )
    
    candindancies.each do |candidancy|
      
      flow_instance = candidancy.flow_instance
      account_info = DsAccount.find_by( external_id: flow_instance.account_id )
      
      Dispatcher.instance.delete_recipients( account_info, 
                                             flow_instance.envelope_id, 
                                             [ candidancy ], 
                                             flow_instance.sender.email )
      candidancy.destroy
    end
    
  end
  
  
  ###################################################################
  private
  ###################################################################
  
  def handle_agent_automation( agent, envelope_info, tabs )
    
    company = Company.find_by( name: agent.contact.name )
    
    unless company.nil?
      
      matcher = CategoryMatcher.instance
      code = matcher.get_category_code( company, tabs )
      unless code.nil?
        
        account_id = envelope_info.get_envelope_param( "AccountId" ).to_i
        routing_order = agent.routing_order
        
        flow_instance = Flow::FlowInstance.where( code: code, envelope_id: envelope_info.envelope_id,
                                                  routing_order: routing_order, company: company,
                                                  account_id: account_id, sender: envelope_info.sender ).first_or_create
        
        candidates = retrieve_candidates( flow_instance )
        
        sender = envelope_info.sender.email
        
        account_info = DsAccount.find_by( external_id: account_id )
        
        dispatcher = Dispatcher.instance          
        @result = dispatcher.add_candidates( account_info, flow_instance.envelope_id, candidates, sender )
        dispatcher.delete_recipients( account_info, flow_instance.envelope_id, [agent], sender )
      end
      
    end
    
  end
  
  def handle_signers_automation( pending_candidates, envelope_info ) 
    
    recipient_ids = pending_candidates.collect do |candidate|
      candidate.recipient_id
    end
    
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
    
    Flow::Candidate.where( flow_instance: flow_instance, sign_date: nil )
    
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
  
  def purge_pending_candidates( flow_instance, candidates, envelope_info )
    
    pending_candidates = candidates.select do |candidate|
      candidate.sign_date.nil?
    end
    
    account_id = envelope_info.get_envelope_param( "AccountId" ).to_i
    sender = envelope_info.sender.email

    account_info = DsAccount.find_by( external_id: account_id )    
    
    dispatcher = Dispatcher.instance   
    @result = dispatcher.delete_recipients( account_info, flow_instance.envelope_id, pending_candidates, sender )
    pending_candidates.destroy_all
  end
end