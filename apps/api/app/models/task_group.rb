# frozen_string_literal: true

class TaskGroup < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy
end
