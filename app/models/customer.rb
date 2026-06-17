class Customer < ApplicationRecord
  belongs_to :user
  has_one :account

  validates :firstname, presence: true
  validates :lastname, presence: true
end
