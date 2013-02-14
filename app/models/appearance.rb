class Appearance < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :guest
  belongs_to :episode
end
