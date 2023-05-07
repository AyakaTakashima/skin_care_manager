require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  setup do
    @product = products(:unused_lotion)
    @heavy_user = users(:heavy_user)
    @no_product_user = users(:no_product_user)
  end

  test 'cannot visit the index if no sign in' do
    visit root_url
    assert_current_path new_user_session_path
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

  test 'the show and index show no log message if product log is no' do
    sign_in @heavy_user
    visit root_url
    within all('.product-record')[0].all('.col')[1] do
      assert_text '使用実績がまだありません。'
    end
    all('.product-record')[0].all('.col')[0].find('.product-image').click
    assert_text '使用実績がまだありません。'
    assert_text '使用開始日や使用終了日を登録すると、ここに実績一覧が表示されます。'
  end

  test 'the show and index show measuring message if product is measuring' do
    sign_in @heavy_user
    visit root_url
    within all('.product-record')[1].all('.col')[1] do
      assert_text '計測中'
    end
    all('.product-record')[1].all('.col')[0].find('.product-image').click
    assert_text '使い切り予定日を計測中です。'
    all('.product-consume-log-record')[0].all('.col')[0] do
      assert_text '使用中'
    end
  end

  test 'the show and index show used message if product is used' do
    sign_in @heavy_user
    visit root_url
    within all('.product-record')[2].all('.col')[1] do
      assert_text "使用開始日を登録すると\n使い切り予定日が表示されます。"
      assert_text '最新の使用履歴'
    end
    all('.product-record')[2].all('.col')[0].find('.product-image').click
    assert_text 'この製品は平均31日に1本使っています。'
    all('.product-consume-log-record')[0].all('.col')[0] do
      assert_text '31日'
    end
  end

  test 'the index show scheduled consume date if product is using' do
    sign_in @heavy_user
    visit root_url
    within all('.product-record')[3].all('.col')[1] do
      assert_text '使い切り予定日'
    end
    all('.product-record')[3].all('.col')[0].find('.product-image').click
    assert_text 'この製品は平均31日に1本使っています。'
    all('.product-consume-log-record')[0].all('.col')[0] do
      assert_text '使い切り予定日から'
    end
  end

  test 'should create product' do
    sign_in @heavy_user
    visit root_url
    click_on 'アイテムを登録する'
    fill_in 'アイテム名', with: '乳液'
    fill_in '価格', with: 5000
    click_on '登録する'
    assert_text 'アイテムを登録しました。'
    assert_text '乳液'
  end

  test 'should update product' do
    sign_in @heavy_user
    visit product_url(@product)
    assert_text '未使用の化粧水'
    click_on 'このアイテムを編集する'
    fill_in 'アイテム名', with: '高い化粧水'
    fill_in '価格', with: 6000
    click_on '登録する'
    assert_text 'アイテムを更新しました。'
    assert_text '高い化粧水'
  end

  test 'should destroy product' do
    sign_in @heavy_user
    visit product_url(@product)
    accept_alert do
      click_on 'このアイテムを削除する'
    end
    assert_text 'アイテムを削除しました。'
  end
end