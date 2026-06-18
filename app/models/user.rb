# frozen_string_literal: true

class User < ApplicationRecord
  has_one :customer, dependent: :restrict_with_error
  has_one :admin, dependent: :restrict_with_error
end
