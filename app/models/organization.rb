class Organization < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  extend FriendlyId
  extend Groupable

  has_many :people
  has_many :appearances, through: :people
  has_many :episodes,    through: :appearances

  mount_uploader :image, ImageUploader

  friendly_id :name, use: :slugged

  scope :with_episodes, joins(:people).
                        order("name ASC").
                        group("organizations.id").
                        having("sum(people.appearances_count) > 0")

  def groupable_by
    self.name.chars.first
  end
end
