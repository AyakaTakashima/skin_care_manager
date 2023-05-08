# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'info@skin-mate.net'
  layout 'mailer'
end
