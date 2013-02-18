class Appearance < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :guest, class_name: "Person", foreign_key: "guest_id"
  belongs_to :episode
end
