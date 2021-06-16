# frozen_string_literal: true

class Token < ApplicationRecord
  belongs_to :user

  validates :token, presence: true, uniqueness: true

  enum status: {
    confirmed: 0,
    revoked: 1
  }
end
