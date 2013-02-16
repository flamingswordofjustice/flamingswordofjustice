class Episode < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  extend FriendlyId

  has_many :appearances
  has_many :guests, through: :appearances

  default_value_for(:published_at) { DateTime.now }

  friendly_id :title, use: :slugged
  validates :title, presence: true
  validates :libsyn_id, uniqueness: true

  mount_uploader :image, ImageUploader
end
