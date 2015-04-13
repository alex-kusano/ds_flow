module ContactsHelper
  
  def build_contact_params 
    { contact_id: @contact.id }
  end
end
