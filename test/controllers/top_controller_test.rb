# frozen_string_literal: true

require 'test_helper'

class TopControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get top_url
    assert_response :success
  end
end