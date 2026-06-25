# frozen_string_literal: true

class Session < ApplicationRecord
  belongs_to :user

  validates :uuid, uniqueness: true
  validates :current_refresh_jti,  uniqueness: true
  validates :expires_at, presence: true

  attribute :uuid, default: -> { SecureRandom.uuid }

  def active?
    expires_at > Time.current && revoked_at.nil?
  end
end
