# frozen_string_literal: true

class ProfanityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || 'cannot contain certain words') unless Profanity.valid?(value)
  end
end
