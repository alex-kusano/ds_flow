class Contact < ActiveRecord::Base
  has_many  :employments
  
  scope  :named, -> param { where ( Contact.arel_table[:name].matches("%#{param}%") ) }
  
  def self.get_contacts_by_employment( employment_params = {} )
    Contact.joins( :employments ).where( employments: employment_params )
  end
  
  def to_s
    "#{name} <#{email}>"
  end
end
