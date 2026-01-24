class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [ :google_oauth2 ]

  enum :role, { admin: 0, regular: 1 }

  # callbacks
  before_create :set_defaults_for_admins

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
  end

  def admin?
    role == "admin"
  end
end
