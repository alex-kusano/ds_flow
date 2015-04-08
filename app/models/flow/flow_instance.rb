class Flow::FlowInstance < ActiveRecord::Base
  has_many :candidates
  belongs_to :company
end
