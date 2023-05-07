class Users::Mailer < Devise::Mailer
  layout 'mailer'
  before_action :add_image

  def devise_mail(record, action, opts = {}, &block)
    opts[:subject] = "【Skinmate】" + I18n.t("devise.mailer.#{action}.subject")
    super
  end

  private

  def add_image
    images = ['logo.svg']

    images.each do |img|
      attachments.inline[img] = File.read("#{Rails.root}/app/assets/images/mailer/" + img)
    end
  end
end

