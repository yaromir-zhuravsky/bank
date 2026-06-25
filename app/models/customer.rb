# frozen_string_literal: true

class Customer < ApplicationRecord
  belongs_to :user
  has_one :account, dependent: :destroy

  validates :firstname, presence: true
  validates :lastname, presence: true
end
