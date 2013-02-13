class Page < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  extend FriendlyId

  friendly_id :title, use: :slugged
end
