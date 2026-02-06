# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/answer_posted_email
  def answer_posted_email
    UserMailer.answer_posted_email
  end
end
