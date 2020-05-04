# frozen_string_literal: true

require 'test_helper'

class BuysControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get buys_index_url
    assert_response :success
  end

  test 'should get order:references' do
    get buys_order: references_url
    assert_response :success
  end
end
