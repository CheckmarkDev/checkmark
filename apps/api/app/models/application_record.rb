# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  after_initialize :generate_uuid, unless: :uuid?

  self.abstract_class = true

  def generate_uuid
    self.uuid = SecureRandom.uuid if defined? uuid
  end

  private

  def uuid?
    has_attribute?(:uuid) && uuid.present?
  end
end
