class EnvelopeRecipient
  attr_reader :contact, :type, :recipient_id, :status, :routing_order, :sign_date, :params
  
  def initialize( recipient_information = {} )    
    
    @recipient_id  = recipient_information[:RecipientId]
    @type          = recipient_information[:Type]    
    @contact       = Contact.where( name:   recipient_information[:UserName], 
                                    email:  recipient_information[:Email] ).first_or_create
    @routing_order = recipient_information[:RoutingOrder].to_i
    @status        = recipient_information[:Status]
    @sign_date     = handle_date( recipient_information[:Signed] )
    
    if recipient_information[:CustomFields].nil? 
      @params      = {}
    else
      @params      = parse_params( recipient_information[:CustomFields][:CustomField] )
    end
  end
  
  def parse_params( param_list_data )    
    
    params = {}
    
    return params if param_list_data.nil? 
    
    if param_list_data.is_a?( Array )
      param_list_data.each do | param_data |
        pair = param_data.split( ':' )
        params[pair[0]] = pair[1]
      end
    else
      pair = param_list_data.split( ':' )
      params[pair[0]] = pair[1]
    end 
    
    params
  end
  
  def get_param( param_name )
    @params[param_name]
  end
  
  def name
    @contact.name
  end
  
  def email
    @contact.email
  end
  
  def match( criteria )
    
    ( (cid=criteria[:orig_id]).nil? or 
      cid.is_a?(Array) ? cid.include?(@params['orig_id']) : cid == @params['orig_id'] ) and
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