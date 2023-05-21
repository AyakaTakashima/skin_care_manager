# frozen_string_literal: true

require 'application_system_test_case'

class ProductConsumeLogsTest < ApplicationSystemTestCase
  setup do
    @product = products(:measuring_lotion)
    @heavy_user = users(:heavy_user)
    sign_in @heavy_user
  end

  test 'should create product consume log' do
    visit products_url
    within all('.product-record')[0].all('.product-col')[2] do
      click_on '使用開始日を登録する'
    end
    fill_in '使用開始日', with: Time.zone.local(2023, 1, 1, 0, 0)
    click_on '使用を開始する'
    assert_text '使用実績を登録しました。'
    within all('.product-record')[0].all('.product-col')[1] do
      assert_text '計測中'
    end
  end

  test 'should record use_ended_at' do
    visit products_url
    within all('.product-record')[1].all('.product-col')[2] do
      click_on '使用終了日を登録する'
    end
    fill_in '使用終了日', with: Time.zone.local(2023, 1, 31, 0, 0)
    click_on '使用を終了する'
    assert_text '使用実績を登録しました。'
    within all('.product-record')[1].all('.product-col')[1] do
      assert_text "使用開始日を登録すると\n使い切り予定日が表示されます。"
      assert_text '最新の使用履歴'
    end
  end
end
