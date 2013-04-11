class Organization < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  extend FriendlyId
  extend Groupable

  has_many :people
  has_many :appearances, through: :people

  mount_uploader :image, ImageUploader

  friendly_id :name, use: :slugged

  scope :with_episodes, joins(:people).
                        order("name ASC").
                        group("organizations.id").
                        having("sum(people.appearances_count) > 0")

  default_scope { order("name ASC") }

  def groupable_by
    self.name.chars.first
  end

  def episodes
    appearances.map(&:episode).compact.uniq
  end

  def episodes_count
    episodes.count
  end
end
