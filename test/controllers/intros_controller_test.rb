require 'test_helper'

class IntrosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get intros_index_url
    assert_response :success
  end

end
