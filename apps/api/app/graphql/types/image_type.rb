# frozen_string_literal: true

module Types
  class ImageType < Types::BaseObject
    field :uuid, ID, null: false
    field :url, String, null: false
    field :thumbnail_url, String, null: false

    def url
      Rails.application.routes.url_helpers.url_for(object)
    end

    def thumbnail_url
      Rails.application.routes.url_helpers.url_for(if object.variable?
                                                     object.variant(resize_to_fill: [
                                                   720, 405
                                                   ])
                                                   else
                                                     object
                                                   end)
    end
  end
end
