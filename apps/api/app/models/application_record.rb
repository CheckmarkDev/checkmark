class ApplicationRecord < ActiveRecord::Base
  after_initialize :generate_uuid, unless: :has_uuid

  self.abstract_class = true

  def generate_uuid
    self.uuid = SecureRandom.uuid if defined? self.uuid
  end

  private

  def has_uuid
    return self.has_attribute?(:uuid) && self.uuid.present?
  end
end
