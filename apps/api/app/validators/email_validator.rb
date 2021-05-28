# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless MailChecker.valid?(value)
      record.errors.add attribute, (options[:message] || "is an invalid email")
    end
  end
end
