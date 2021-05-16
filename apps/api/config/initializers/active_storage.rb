# frozen_string_literal: true

ActiveStorage::Current.host = ENV.fetch('ASSET_HOST', 'https://api.checkmark.dev')
