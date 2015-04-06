module EmploymentsHelper
  
  def get_companies
    Company.all
  end
  
  def get_selected_company( employment )
    if employment.company_id.nil?
      if params[:company_id].nil?
        return "0"
      else
        "#{params[:company_id]}"
      end
    else
      return "#{employment.company_id}"
    end
  end

  def get_roles
    Role.all
  end

  def get_selected_role( employment )
    if employment.role_id.nil?
      return "0"
    else
      return employment.role_id
    end
  end

  def get_contacts
    Contact.all
  end

  def get_selected_contact( employment )
    if employment.contact_id.nil? 
      if params[:contact_id].nil?
        return "0"
      else
        return "#{params[:contact_id]}"
      end
    else
      return "#{employment.contact_id}"
    end
  end

end
