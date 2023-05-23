# frozen_string_literal: true

require 'test_helper'

class TopControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get top_url
    assert_response :success
  end

  test 'should get pp' do
    get pp_url
    assert_response :success
  end

  test 'should get tos' do
    get tos_url
    assert_response :success
  end
end
