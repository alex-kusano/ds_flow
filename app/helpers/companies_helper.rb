module CompaniesHelper
  
  def build_company_params
    { company_id: @company.id }
  end
end
