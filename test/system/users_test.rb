require 'application_system_test_case'

class ProductsTest < ApplicationSystemTestCase
  setup do
    @user = users(:heavy_user)
    ActionMailer::Base.deliveries.clear
  end

  test 'creating a new user account' do
    visit new_user_registration_path

    fill_in 'Eメール', with: 'test@example.com'
    fill_in 'パスワード', with: 'password123'
    fill_in 'パスワード（確認用）', with: 'password123'
    click_button 'アカウント作成'

    assert_text 'アカウント登録が完了しました。'
  end

  test 'cannot create a new user account without email' do
    visit new_user_registration_path

    fill_in 'パスワード', with: 'password123'
    fill_in 'パスワード（確認用）', with: 'password123'
    click_button 'アカウント作成'

    assert_text 'メールアドレスは必須です'
    assert_current_path new_user_registration_path
  end

  test 'cannot create a new user account without password' do
    visit new_user_registration_path

    click_button 'アカウント作成'

    fill_in 'Eメール', with: 'test@example.com'
    assert_text 'パスワードは必須です'
    assert_current_path new_user_registration_path
  end

  test 'cannot create a new user account without password for confirmation' do
    visit new_user_registration_path

    click_button 'アカウント作成'

    fill_in 'Eメール', with: 'test@example.com'
    fill_in 'パスワード', with: 'password123'
    assert_text '確認用パスワードは必須です'
    assert_current_path new_user_registration_path
  end

  test 'can login' do
    visit new_user_session_path
    fill_in 'Eメール', with: 'heavy_user@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'
    assert_current_path root_path
  end

  test 'cannot login without password' do
    visit new_user_session_path
    fill_in 'Eメール', with: 'heavy_user@example.com'
    click_on 'ログイン'
    assert_text 'パスワードは必須です'
    assert_current_path new_user_session_path
  end

  test 'cannot login without email' do
    visit new_user_session_path
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'
    assert_text 'メールアドレスは必須です'
    assert_current_path new_user_session_path
  end

  test 'can logout' do
    sign_in @user
    visit root_url
    click_on 'logout'
    assert_current_path new_user_session_path
  end

  test 'can edit password' do
    visit new_user_session_path
    fill_in 'Eメール', with: 'heavy_user@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'
    assert_current_path root_path
    click_on 'logout'
    assert_current_path new_user_session_path

    visit new_user_password_url
    fill_in 'Eメール', with: 'heavy_user@example.com'
    click_on '送信'
    assert_text 'パスワードの再設定について数分以内にメールでご連絡いたします。'

    assert_equal 1, ActionMailer::Base.deliveries.size
    mail = ActionMailer::Base.deliveries.last
    assert_equal @user.email, mail.to[0]
    assert_equal '【Skinmate】パスワードの再設定について', mail.subject

    user = User.find_by(email: @user.email)
    token = user.send(:set_reset_password_token)
    visit edit_user_password_path(reset_password_token: token)
    assert_selector 'h1', text: 'パスワードの再設定'
    fill_in 'パスワード', with: 'password123'
    fill_in 'パスワード（確認用）', with: 'password123'
    click_on 'パスワードを変更する'

    visit new_user_session_path
    fill_in 'Eメール', with: 'heavy_user@example.com'
    fill_in 'パスワード', with: 'password123'
    click_on 'ログイン'
    assert_current_path root_path
    click_on 'logout'
    assert_current_path new_user_session_path

    fill_in 'Eメール', with: 'heavy_user@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'
    assert_text 'Eメールまたはパスワードが違います。'
    assert_current_path new_user_session_path
  end

  test 'can edit email at user edit page' do
    sign_in @user
    visit edit_user_registration_path
    assert_selector 'h1', text: 'アカウント設定'
    fill_in 'Eメール', with: 'heavy_user_edit_mail_address@example.com'
    fill_in '現在のパスワード', with: 'password'
    click_on '上記の内容で変更する'
    assert_text 'アカウント情報を変更しました。'
    assert_equal 1, ActionMailer::Base.deliveries.size
    mail = ActionMailer::Base.deliveries.last
    assert_equal @user.email, mail.to[0]
    assert_equal '【Skinmate】メール変更完了', mail.subject

  end

  test 'can edit password at user edit page' do
    sign_in @user
    visit edit_user_registration_path
    assert_selector 'h1', text: 'アカウント設定'
    fill_in '現在のパスワード', with: 'password'
    fill_in 'パスワード', with: 'password123'
    fill_in 'パスワード（確認用）', with: 'password123'
    click_on '上記の内容で変更する'
    assert_text 'アカウント情報を変更しました。'
    assert_equal 1, ActionMailer::Base.deliveries.size
    mail = ActionMailer::Base.deliveries.last
    assert_equal @user.email, mail.to[0]
    assert_equal '【Skinmate】パスワードの変更について', mail.subject
  end
end
