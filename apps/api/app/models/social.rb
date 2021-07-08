# frozen_string_literal: true

class Social < ApplicationRecord
  belongs_to :user
  belongs_to :project
end
