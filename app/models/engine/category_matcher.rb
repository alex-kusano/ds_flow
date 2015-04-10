class CategoryMatcher
  
  @@instance = CategoryMatcher.new
  
  def self.instance
    @@instance
  end
  
  def get_category_code( company, tabs )    
    unless company.nil? || company.categories.nil?
      company.categories.each do |category|
        code = extract_code( category, tabs )
        return code unless code.blank?       
      end
    end
    return nil
  end
  
  def extract_code( category, tabs ) 
    if matches?( category, tabs )
      unless category.subcategories.nil?
        category.subcategories.each do |subcategory|
          code = extract_code( subcategory, tabs )
          return code unless code.blank?
        end
      end
      return category.code    
    end
    return nil
  end
  
  def matches?( category, tabs )
    
    cur_value = tabs[category.tab_name]
    
    if cur_value.nil?
      return category.datatype == Category.NIL
    end
    
    case category.datatype
    when Category.INTEGER
      tab_value = cur_value.to_i
      exp_value = category.tab_value.to_i
    when Category.FLOAT
      tab_value = cur_value.to_f
      exp_value = category.tab_value.to_f
    when Category.DATE
      tab_value = DateTime.parse(cur_value)
      exp_value = DateTime.parse(category.tab_value)
    else
      tab_value = cur_value
      exp_value = category.tab_value
    end
    
    case category.operation
    when Category.EQUAL_TO
      return tab_value == exp_value
    when Category.LESS_THAN
      return tab_value < exp_value
    when Category.LESS_THAN_OR_EQUAL
      return tab_value <= exp_value
    when Category.GREATER_THAN
      return tab_value > exp_value
    when Category.GREATER_THAN_OR_EQUAL
      return tab_value >= exp_value
    when Category.NOT_EQUAL
      return tab_value != exp_value
    end
  end
  
  
end