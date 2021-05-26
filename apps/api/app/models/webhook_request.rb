class WebhookRequest < ApplicationRecord
  belongs_to :webhook

  enum state: {
    pending: 0,
    delivered: 1,
    failed: 2
  }

end
