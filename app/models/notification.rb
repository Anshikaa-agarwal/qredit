class Notification < ApplicationRecord
  # associations
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
end
