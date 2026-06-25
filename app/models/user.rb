# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_one :customer, dependent: :destroy
  has_one :admin, dependent: :destroy
  has_many :sessions, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :uuid, uniqueness: true

  attribute :uuid, default: -> { SecureRandom.uuid }
end
