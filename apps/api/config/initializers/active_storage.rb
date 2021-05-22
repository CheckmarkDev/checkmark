# frozen_string_literal: true

module ActiveStorageAttachmentList
  extend ActiveSupport::Concern

  included do
    after_initialize :generate_uuid, unless: :uuid?

    def generate_uuid
      self.uuid = SecureRandom.uuid if defined? uuid
    end

    private

    def uuid?
      has_attribute?(:uuid) && uuid.present?
    end
  end
end

Rails.configuration.to_prepare do
  ActiveStorage::Attachment.send :include, ActiveStorageAttachmentList
end

ActiveStorage::Current.host = ENV.fetch('ASSET_HOST', 'https://api.checkmark.dev')
