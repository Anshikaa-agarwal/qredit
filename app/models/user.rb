class User < ApplicationRecord
  # constants
  VALID_AVATAR_EXTENSIONS = %w[ jpg jpeg png avif webp ]

  def to_param
    username.presence || id.to_s
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [ :google_oauth2 ]

  enum :role, { admin: 0, regular: 1 }

  # callbacks
  before_validation :set_username, on: :create
  before_create :set_defaults_for_admins

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
  validate  :avatar_image_format
  # password and email are validated with devise.

  # attachments
  has_one_attached :avatar

  def after_confirmation
    after_verification_settings
  end

  def set_username
    return if username

    base_username = email.split("@").first if email.present?
    check_username = base_username

    while User.exists?(username: check_username)
      check_username = "#{base_username}#{SecureRandom.hex(3)}"
    end

    self.username = check_username
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    account = User.where(email: data["email"]).first
    account ||= User.create(name: data["name"], email: data["email"], password: Devise.friendly_token[0, 20])
    account
  end

  def displayed_avatar
    if avatar.attached? && avatar.persisted?
      avatar
    else
      "placeholder_user_avatar.png"
    end
  end

  def admin?
    role == "admin"
  end

  private

  def set_defaults_for_admins
    if admin?
      verified = true
      confirmed_at = Time.now
    end
  end

  def after_verification_settings
    User.transaction do
      update!(
        verified: true,
        credits: credits + 5,
        auth_token: SecureRandom.hex(20)
      )

      credit_transactions.create!(
        reason: "User email verified",
        type: :earnt,
        units: 5
      )
    end
  end

  def avatar_image_format
    if avatar.attached? && !avatar.filename.extension.in?(VALID_AVATAR_EXTENSIONS)
      avatar.purge
      errors.add(:avatar, "must be an image of valid extension.")
    end
  end
end
