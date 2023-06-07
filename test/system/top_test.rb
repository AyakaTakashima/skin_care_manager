# frozen_string_literal: true

require 'application_system_test_case'

class TopTest < ApplicationSystemTestCase
  test 'visiting the index' do
    visit top_url
    assert_current_path top_path
  end

  test 'visiting pp' do
    visit pp_url
    assert_current_path pp_path
  end

  test 'visiting tos' do
    visit tos_url
    assert_current_path tos_path
  end
end
