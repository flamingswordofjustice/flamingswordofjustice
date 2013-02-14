class Episode < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  extend FriendlyId

  has_many :appearances
  has_many :guests, through: :appearances

  default_value_for(:recorded_at) { Date.today }

  friendly_id :title, use: :slugged
  validates :title, presence: true
end
