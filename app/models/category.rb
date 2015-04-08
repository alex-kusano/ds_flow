class Category < ActiveRecord::Base
  EQUAL_TO               = 0
  LESS_THAN              = 1
  LESS_THAN_OR_EQUAL     = 2
  GREATER_THAN           = 3
  GREATER_THAN_OR_EQUAL  = 4
  
  STRING                 = 0
  INTEGER                = 1
  FLOAT                  = 2
  DATE                   = 3
  
  belongs_to   :company
  has_many     :subcategories,     class_name: "Category",  foreign_key: "parent_id"
  belongs_to   :parent,            class_name: "Category"
  
  def to_s
    "#{tab_name} #{operation_string} #{tab_value} => #{code}"
  end
    
  def operation_string
    case operation
      when EQUAL_TO
        "="
      when LESS_THAN
        "<"
      when LESS_THAN_OR_EQUAL
        "<="
      when GREATER_THAN
        ">"
      when GREATER_THAN_OR_EQUAL
        ">="
      else
      "Unknown operation"
    end
  end
  
  def datatype_string
    case operation
      when STRING
        "STRING"
      when INTEGER
        "INTEGER"
      when FLOAT
        "FLOAT"
      when DATE
        "DATE"
      else
        "Unknown Datatype"
    end
  end
  
  def self.EQUAL_TO
    EQUAL_TO
  end
  
  def self.LESS_THAN
    LESS_THAN
  end
  
  def self.LESS_THAN_OR_EQUAL
    LESS_THAN_OR_EQUAL
  end
  
  def self.GREATER_THAN
    GREATER_THAN
  end
  
  def self.GREATER_THAN_OR_EQUAL
    GREATER_THAN_OR_EQUAL
  end
  
  def self.STRING
    STRING
  end
  
  def self.INTEGER
    INTEGER
  end
  
  def self.FLOAT
    FLOAT
  end
  
  def self.DATE
    DATE
  end
  
end

  