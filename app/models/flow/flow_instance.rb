class Flow::FlowInstance < ActiveRecord::Base
  has_many :candidates
end
