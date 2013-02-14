class Guest < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  has_many :appearances
  has_many :episodes, through: :appearances
  belongs_to :organization

  mount_uploader :image, ImageUploader
end
