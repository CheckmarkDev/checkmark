# frozen_string_literal: true

require 'yaml'

module Profanity
  BLACKLIST = YAML.load_file('./lib/profanity.yml').freeze

  def self.valid?(text)
    !blacklisted?(text)
  end

  def self.blacklisted?(text)
    blacklisted = BLACKLIST.select { |word| text.downcase.include?(word.downcase) }
    blacklisted.size.positive?
  end
end
