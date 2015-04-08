module CategoriesHelper
  
  def get_companies
    Company.all
  end
  
  def get_selected_company( category )
    if category.company_id.nil?
      if params[:company_id].nil?
        return "0"
      else
        "#{params[:company_id]}"
      end
    else
      return "#{category.company_id}"
    end
  end
  
  def get_datatypes
    [["STRING",  0],
     ["INTEGER", 1],
     ["FLOAT",   2]]
  end
  
  def get_selected_datatype( category )
    if category.datatype.nil?
      return "0"      
    else
      return "#{category.datatype}"
    end
  end
  
  def get_operations
    [["=",  0],
     ["<",  1],
     ["<=", 2],
     [">",  3],
     [">=", 4]]
  end
  
  def get_selected_operation( category )
    if category.operation.nil?
      return "0"      
    else
      return "#{category.operation}"
    end
  end
  
  def get_categories
    Category.all
  end
  
  def get_selected_category( category )
    if category.parent_id.nil?
      if params[:parent_id].nil?
        return "0"
      else
        "#{params[:parent_id]}"
      end
    else
      return "#{category.parent_id}"
    end
  end

  def build_category_params( subcategory = nil )
    built_params = {}    
    built_params[:parent_id] = params[:id]
    unless subcategory.nil?
      built_params[:id] =  subcategory.id 
    end
    built_params
  end
end
