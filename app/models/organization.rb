class Organization < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  extend FriendlyId

  has_many :guests
  has_many :appearances, through: :guests

  mount_uploader :image, ImageUploader

  friendly_id :name, use: :slugged
end
