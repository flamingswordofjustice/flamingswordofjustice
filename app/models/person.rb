class Person < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  extend FriendlyId

  has_many :appearances, foreign_key: "guest_id"
  has_many :episodes, through: :appearances
  belongs_to :organization

  mount_uploader :image, ImageUploader

  friendly_id :name, use: :slugged
end
