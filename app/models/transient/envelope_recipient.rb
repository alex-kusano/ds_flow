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
    
    ( criteria[:type].nil? or @type == criteria[:type] ) and
    ( criteria[:routing_order].nil? or @routing_order == criteria[:routing_order] ) and
    ( criteria[:status].nil? or @status == criteria[:status] )
    
  end
  
  private
  
  def handle_date( date_info ) 
    return nil if date_info.blank?
    DateTime.parse(date_info)
  end
  
end