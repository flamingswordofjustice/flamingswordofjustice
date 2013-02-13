class Appearance < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :guest
  belongs_to :show
end
