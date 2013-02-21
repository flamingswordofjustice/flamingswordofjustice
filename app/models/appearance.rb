class Appearance < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :guest, class_name: "Person", foreign_key: "guest_id", dependent: :destroy, counter_cache: true
  belongs_to :episode, dependent: :destroy

  validates :guest_id, presence: true
  validates :episode_id, presence: true
end
