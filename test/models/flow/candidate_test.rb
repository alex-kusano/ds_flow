require 'test_helper'

class Flow::CandidateTest < ActiveSupport::TestCase
  
  def setup
    @candidate = flow_candidates(:candidate_A)
  end
  
  test "valid candidate" do
    assert @candidate.valid?
  end
  
  test "Instance must be present" do
    @candidate.flow_instance = nil
    assert_not @candidate.valid?
  end
  
  test "Employment must be present" do
    @candidate.employment = nil
    assert_not @candidate.valid?
  end
  
  test "Recipient Id must be present" do
    @candidate.recipient_id = nil
    assert_not @candidate.valid?
  end
  
end
