class Contact < ActiveRecord::Base
  # ASSOCIATIONS
  has_many  :employments, dependent: :destroy
  
  # VALIDATIONS
  validates      :name, :email, presence: true
  
  # SCOPES
  scope  :named, -> param { where ( Contact.arel_table[:name].matches("%#{param}%") ) }
  
  # CLASS METHODS
  def self.get_contacts_by_employment( employment_params = {} )
    Contact.joins( :employments ).where( employments: employment_params )
  end
  
  # UTILITY_METHODS
  def to_s
    "#{name} <#{email}>"
  end
end
