class NotifyUserOnQuestionPostedJob < ApplicationJob
  queue_as :default

  def perform(question, users_to_notify)
    users_to_notify.each do |user|
      notification = Notification.create!(
        user: user,
        notifiable: question,
        message: "#{question.user.name} posted a new question to a topic you follow."
      )

      notification.broadcast_prepend_to(
        "notifications_#{user.id}",
        target: "notifications",
        partial: "notifications/notification",
        locals: { notification: notification }
      )
    end
  end
end
