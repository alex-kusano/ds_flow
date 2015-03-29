require 'transient/envelope_recipient'

class EnvelopeInformation
  attr_reader :envelope_id, :envelope_status, :sender, :recipients
  
  #
  def initialize( envelope_information = {} )
    if not envelope_information.blank? and envelope_information.is_a?(Hash)
      envelope_data = envelope_information[:EnvelopeStatus]
      
      @envelope_id = envelope_data[:EnvelopeID]
      @sender = Contact.where(name: envelope_data[:UserName], email: envelope_data[:Email] ).first_or_create
      @envelope_status = envelope_data[:Status]
      
      extract_params(envelope_data)
      extract_recipients(envelope_data)
    end
  end
  
  #
  def get_envelope_param( param_name ) 
    @envelope_params[param_name] 
  end
  
  def get_recipients( criteria = {} )     
    @recipients.select do |candidate|
      candidate.match( criteria )
    end
  end
  
  ###################################################################
  private
  ###################################################################
  
  #  
  def extract_params( envelope_data )
    param_list = envelope_data[:CustomFields][:CustomField]
    @envelope_params = {}
    if not param_list.blank?
      param_list.each do |item|         
        @envelope_params[item[:Name]] = item[:Value]
      end
    end
  end
  
  #
  def extract_recipients( envelope_data )
    recipient_list = envelope_data[:RecipientStatuses][:RecipientStatus]
    @recipients = []
    if not recipient_list.blank?
      recipient_list.each do |recipient_data|
        recipient = EnvelopeRecipient.new(recipient_data)
        @recipients.push recipient
      end
    end
  end
  
end