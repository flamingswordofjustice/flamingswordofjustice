class Topic < ActiveRecord::Base
  extend FriendlyId
  extend Groupable

  has_many :topic_assignments
  validates :name, uniqueness: true

  mount_uploader :image, ImageUploader
  friendly_id :name, use: :slugged

  default_scope { order("name ASC") }

  scope :with_episodes, joins(:topic_assignments).
                        group("topics.id").
                        where("topic_assignments.assignable_type = ?", Episode.name).
                        having("count(topic_assignments.id) > 0")

  def assignables
    topic_assignments.includes(:assignable).map &:assignable
  end

  def episodes
    topic_assignments.episodes.includes(:assignable).map &:assignable
  end

  def groupable_by
    self.name.chars.first.upcase
  end

  def alphabet
    ("A".."Z").to_a
  end

  def episodes_count
    topic_assignments.episodes.count
  end
end
