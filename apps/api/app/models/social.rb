# frozen_string_literal: true

class Social < ApplicationRecord
  belongs_to :socialable, polymorphic: true
end
