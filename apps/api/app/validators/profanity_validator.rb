# frozen_string_literal: true

class ProfanityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if Profanity.valid?(value)

    blacklist = Profanity.blacklist(value).join(',')
    record.errors.add attribute,
                      (options[:message] || "cannot contain certain words like '#{blacklist}'")
  end
end
