module CompaniesHelper
  
  def build_company_params( company ) 
    { company_id: company.id }
  end
end
