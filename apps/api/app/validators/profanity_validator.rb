# frozen_string_literal: true

class ProfanityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless Profanity.valid?(value)
      record.errors.add attribute, (options[:message] || "cannot contain certain words")
    end
  end
end
