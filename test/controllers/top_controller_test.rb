# frozen_string_literal: true

require 'test_helper'

class TopControllerTest < ActionDispatch::IntegrationTest
  test 'should get index, pp and tos' do
    get top_url
    assert_response :success

    get pp_url
    assert_response :success

    get tos_url
    assert_response :success
  end
end
