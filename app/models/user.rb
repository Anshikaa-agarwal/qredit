class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [ :google_oauth2 ]

  enum :role, { admin: 0, regular: 1 }

  # callbacks
  before_create :set_defaults_for_admins
  after_commit :attach_default_avatar, on: [ :create ]

  # associations
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

  has_many :topic_assignements, as: :topicable, dependent: :destroy
  has_many :topics, through: :topic_assignements

  has_many :credit_transactions, dependent: :destroy
  has_many :credit_purchases, dependent: :destroy

  has_many :notifications, dependent: :destroy

  has_many :abuse_reports, class_name: "Abuse", foreign_key: :reporter_id, dependent: :destroy

  has_many :followers_relationships, class_name: "Follower", foreign_key: :followee_id
  has_many :following_relationships, class_name: "Follower", foreign_key: :follower_id

  has_many :followers, through: :followers_relationships, source: :follower
  has_many :followees, through: :following_relationships, source: :followee

  # validations
  validates :name,  presence: true
  validates :credits, numericality: :only_integer
  # password and email are validated with devise.

  # attachments
  has_one_attached :avatar

  def after_confirmation
    after_verification_settings
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    account = User.where(email: data["email"]).first
    account ||= User.create(name: data["name"], email: data["email"], password: Devise.friendly_token[0, 20])
    account
  end

  def displayed_avatar
    avatar.attached? ? avatar : "placeholder_user_avatar.png"
  end

  private

  def set_defaults_for_admins
    if admin?
      verified = true
      confirmed_at = Time.now
    end
  end

  def after_verification_settings
    update!(
      verified: true,
      credits: credits + 5,
      auth_token: SecureRandom.hex(20)
    )

    credit_transactions.create!(
      reason: 'User email verified',
      status: :earnt,
      units: 5
    )
  end

  def admin?
    role == "admin"
  end

  def attach_default_avatar
    return if avatar.attached?

    avatar.attach(
      io: File.open(Rails.root.join("app/assets/images/placeholder_user_avatar.png")),
      filename: "placeholder_user_avatar.png",
      content_type: "image/png"
    )
  end
end
