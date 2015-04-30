require 'engine/flow_handler'

class Employment < ActiveRecord::Base
  
  # ASSOCIATIONS
  belongs_to :company
  belongs_to :contact
  belongs_to :role
  
  # VALIDATIONS
  validates      :company, :role, :contact, presence: true
  
  # CALLBACKS
  after_create    :notify_created
  before_update   :notify_updated
  before_destroy  :notify_destroyed
  
  # METHODS
  def notify_created
    FlowHandler.instance.employment_created(self)
  end
  
  def notify_updated
    FlowHandler.instance.employment_updated(self)
  end
  
  def notify_destroyed
    FlowHandler.instance.employment_destroyed(self)
  end
  
  
end
