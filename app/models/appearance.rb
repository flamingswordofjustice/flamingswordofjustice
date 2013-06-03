class Appearance < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :guest, polymorphic: true, dependent: :destroy, counter_cache: true
  belongs_to :episode, dependent: :destroy

  validates :guest_id, presence: true
  validates :episode_id, presence: true
end
