class EnvelopeRecipient
  attr_reader :contact, :type, :status, :routing_order, :sign_date
  
  def initialize( recipient_information = {} )    
    @type          = recipient_information[:Type]
    @contact       = Contact.where( name:   recipient_information[:UserName], 
                                    email:  recipient_information[:Email] ).first_or_create
    @routing_order = recipient_information[:RoutingOrder]
    @status        = recipient_information[:Status]
    @sign_date     = handle_date( recipient_information[:Signed] )
  end
  
  def name
    contact.name
  end
  
  def email
    contact.email
  end
  
  def match( criteria )
    
    ( (ctype=criteria[:type]).nil? or 
      ctype.is_a?(Array) ? ctype.include?(@type) : ctype == @type ) and
    ( (corder=criteria[:routing_order]).nil? or 
      corder.is_a?(Array) ? corder.include?(@routing_order) : corder == @routing_order ) and
    ( (cstatus=criteria[:status]).nil? or 
      cstatus.is_a?(Array) ? cstatus.include?(@status) : cstatus == @status )
    
  end
  
  private
  
  def handle_date( date_info ) 
    return nil if date_info.blank?
    DateTime.parse(date_info)
  end
  
end