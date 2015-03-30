class Rule < ActiveRecord::Base
  belongs_to :rule_set
  has_many   :criteria
end
