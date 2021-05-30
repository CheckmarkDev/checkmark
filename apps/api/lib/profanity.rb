# frozen_string_literal: true

require 'yaml'

module Profanity
  BLACKLIST = YAML.load_file('./lib/profanity.yml').freeze

  def self.valid?(text)
    !blacklisted?(text)
  end

  def self.blacklist(text)
    BLACKLIST.select { |word| text.split(' ').map(&:downcase).include?(word.downcase) }
  end

  def self.blacklisted?(text)
    blacklist = blacklist(text)
    blacklist.size.positive?
  end
end
