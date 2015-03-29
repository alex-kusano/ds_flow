class Criterium < ActiveRecord::Base
  belongs_to :rule
  belongs_to :role
end
