# frozen_string_literal: true

require 'faraday_middleware'

class Link < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, profanity: true, length: { minimum: 2, maximum: 255 }
  validates :url, url: { allow_nil: true, no_local: true, public_suffix: true, allow_blank: false }

  before_validation :fetch_title

  def fetch_title
    title = nil
    begin
      conn = Faraday.new do |f|
        f.request :retry
        f.response :follow_redirects
      end

      response = conn.get url
      title = Nokogiri::HTML(response.body).at_css('title').text
    rescue StandardError => e
      Rails.logger.info e
    end

    self.title = title
  end
end
