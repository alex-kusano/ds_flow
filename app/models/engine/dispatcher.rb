require 'net/http'

class Dispatcher
  
  def add_candidates( envelope_id, candidates = [] )
    
    json_list = candidates.collect do |candidate|
      json_new_signer( candidate )
    end
    
    body =   "{"
    body <<    "\"signers\" : ["
    body <<    json_list.join(",")
    body <<    "]"
    body <<  "}"
    
    uri = URI.parse("https://4d9559eb.proxy.webhookapp.com/restapi/v2/accounts/805418/envelopes/#{envelope_id}/recipients")
    
    
    Net::HTTP.start( uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Post.new( uri, get_headers )

      return response = http.request( request, body ) # Net::HTTPResponse object
    end      
  end
  
  def delete_recipients( envelope_id, recipients = [] )
    
    agents = json_del_list_by_type( recipients, 'Agent')
    signers = json_del_list_by_type( recipients, 'Signer' )
    
    body =   "{"
    body <<    "\"agents\" : ["
    body <<      agents.join(",")
    body <<    "],"
    body <<    "\"signers\" : ["
    body <<      signers.join(",")
    body <<    "]"
    body <<  "}"
    
    uri = URI.parse("https://4d9559eb.proxy.webhookapp.com/restapi/v2/accounts/805418/envelopes/#{envelope_id}/recipients")
    
    Net::HTTP.start( uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Delete.new( uri, get_headers )

      return response = http.request( request, body ) # Net::HTTPResponse object
    end 
    response.body    
  end
  
  def get_headers 
    { "Content-Type" => "application/json", 
      "Accept" => "application/json",
      "X-DocuSign-Authentication" => "{\"Username\": \"53566da0-fe06-4d6b-b7df-6f2d49a8d603\", \"Password\":\"IOWKvFiF/cHhVgJccYl79nxv/E0=\", \"IntegratorKey\":\"COMP-57f6e829-b796-41e3-80fe-1ab250a4a8ec\"}" }
  end
  
  ###################################################################
  private
  ###################################################################
  
  def json_new_signer( recipient ) 
    json =   "{"
    json <<    "\"email\" : \"#{recipient.contact.email}\"," 
    json <<    "\"name\" : \"#{recipient.contact.name}\","
    json <<    "\"routingOrder\" : \"#{recipient.routing_order+1}\","
    json <<    "\"recipientId\" : \"#{recipient.recipient_id}\","
    json <<    "\"customFields\" : [\"orig_id:#{recipient.recipient_id}\"]"
    json <<  "}"
  end
  
  def json_del_list_by_type( recipient_list, type )
    
    filtered_list = recipient_list.select do |recipient| 
      recipient.type == type
    end
    
    json_list = filtered_list.collect do |recipient|
      json_del( recipient )
    end
    
    return json_list
  end

  def json_del( recipient )
    
    json =  "{"
    json <<    "\"recipientId\" : \"#{recipient.recipient_id}\""    
    json << "}"
    
  end
  
  
  
end