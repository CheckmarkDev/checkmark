class Project < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tasks
  has_many_attached :screenshots
  has_one_attached :avatar

end
