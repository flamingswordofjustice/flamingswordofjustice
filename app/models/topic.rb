class Topic < ActiveRecord::Base
  extend FriendlyId
  extend Groupable

  has_many :topic_assignments
  validates :name, uniqueness: true

  def assignables
    topic_assignments.includes(:assignable).map &:assignable
  end

  mount_uploader :image, ImageUploader
  friendly_id :name, use: :slugged

  scope :with_episodes, joins(:topic_assignments).
                        order("name ASC").
                        group("topics.id").
                        where("topic_assignments.assignable_type = ?", Episode.name).
                        having("count(topic_assignments.id) > 0")

  def groupable_by
    self.name.chars.first
  end
end
