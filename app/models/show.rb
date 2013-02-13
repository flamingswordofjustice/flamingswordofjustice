class Show < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  has_many :appearances
  has_many :guests, through: :appearances

  default_value_for(:recorded_at) { Date.today }
end
