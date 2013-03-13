class Organization < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  extend FriendlyId

  has_many :people
  has_many :appearances, through: :people
  has_many :episodes,    through: :appearances

  mount_uploader :image, ImageUploader

  friendly_id :name, use: :slugged
end
