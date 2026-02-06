class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.answer_posted_email.subject
  #

  default from: 'support@qredit.com'

  def answer_posted_email
    @user = params[:user]
    @question = params[:question]

    mail(to: @user.email, subject: 'An answer posted on your question!')
  end
end
