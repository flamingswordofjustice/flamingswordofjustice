class Organization < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  has_many :guests
  has_many :appearances, through: :guests

  mount_uploader :image, ImageUploader
end
