class Topic < ActiveRecord::Base
  extend FriendlyId

  has_many :topic_assignments
  validates :name, uniqueness: true

  def assignables
    topic_assignments.includes(:assignable).map &:assignable
  end

  mount_uploader :image, ImageUploader
  friendly_id :name, use: :slugged
end
