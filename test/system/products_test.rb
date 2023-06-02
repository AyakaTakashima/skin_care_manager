# frozen_string_literal: true

require 'application_system_test_case'

class ProductsTest < ApplicationSystemTestCase
  setup do
    @product = products(:unused_lotion)
    @heavy_user = users(:heavy_user)
    @no_product_user = users(:no_product_user)
  end

  test 'cannot visit the index if no sign in' do
    visit root_url
    assert_equal '基礎化粧品の使用サイクル管理アプリ | Skinmate（スキンメイト）', title
  end

  test 'cannot visit the show if no sign in' do
    visit product_url(@product)
    assert_current_path new_user_session_path
  end

  test 'visiting the index' do
    sign_in @heavy_user
    visit root_url
    assert_current_path root_path
  end

  test 'the index show blank message if no product' do
    sign_in @no_product_user
    visit root_url
    assert_text 'アイテムの登録はされていません。'
  end

  test 'the show and index show no log message if product log is none' do
    sign_in @heavy_user
    visit root_url
    within all('.product-record')[0].all('.product-col')[1] do
      assert_text '使用実績がまだありません。'
    end
    all('.product-record')[0].all('.product-col')[0].find('.is-image-link').click
    assert_text '使用実績がまだありません。'
    assert_text '使用開始日や使用終了日を登録すると、'
    assert_text 'ここに実績一覧が表示されます。'
  end

  test 'the show and index show measuring message if product is measuring' do
    sign_in @heavy_user
    visit root_url
    within all('.product-record')[1].all('.product-col')[1] do
      assert_text '計測中'
    end
    all('.product-record')[1].all('.product-col')[0].find('.is-image-link').click
    assert_text '使い切り予定日を計測中です。'
    all('.product-consume-log-record')[0].all('.col')[0] do
      assert_text '使用中'
    end
  end

  test 'the show and index show used message if product is used' do
    sign_in @heavy_user
    visit root_url
    within all('.product-record')[2].all('.product-col')[1] do
      assert_text "使用開始日を登録すると\n使い切り予定日が表示されます。"
      assert_text '最新の使用履歴'
    end
    all('.product-record')[2].all('.product-col')[0].find('.is-image-link').click
    assert_text '平均31日に1本使っています。'
    all('.product-consume-log-record')[0].all('.col')[0] do
      assert_text '31日'
    end
  end

  test 'the index show scheduled consume date if product is using' do
    sign_in @heavy_user
    visit root_url
    within all('.product-record')[3].all('.product-col')[1] do
      assert_text '使い切り予定日'
    end
    all('.product-record')[3].all('.product-col')[0].find('.is-image-link').click
    assert_text '平均31日に1本使っています。'
    all('.product-consume-log-record')[0].all('.col')[0] do
      assert_text '使い切り予定日から'
    end
  end

  test 'should create product' do
    sign_in @heavy_user
    visit root_url
    click_on 'アイテムを登録'
    fill_in 'アイテム名', with: '乳液'
    fill_in '価格', with: 5000
    click_on '登録'
    assert_text 'アイテムを登録しました。'
    assert_text '乳液'
  end

  test 'should update product' do
    sign_in @heavy_user
    visit product_url(@product)
    assert_text '未使用の化粧水'
    click_on 'アイテムを編集'
    fill_in 'アイテム名', with: '高い化粧水'
    fill_in '価格', with: 6000
    click_on '登録'
    assert_text 'アイテムを更新しました。'
    assert_text '高い化粧水'
  end

  test 'should destroy product' do
    sign_in @heavy_user
    visit product_url(@product)
    accept_alert do
      click_on 'アイテムを削除'
    end
    assert_text 'アイテムを削除しました。'
  end
end
