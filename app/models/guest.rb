class Guest < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  has_many :appearances
  has_many :shows, through: :appearances
  belongs_to :organization
end
