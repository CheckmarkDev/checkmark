require 'faraday_middleware'

class Link < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, profanity: true, length: { minimum:2, maximum: 255 }
  validates :url, url: { allow_nil: true, no_local: true, public_suffix: true, allow_blank: false }

  before_validation :fetch_title

  def fetch_title
    title = nil

    conn = Faraday.new do |f|
      f.request :retry
      f.response :follow_redirects
    end

    response = conn.get self.url
    title = Nokogiri::HTML(response.body).at_css('title').text

    self.title = title
  end
end
