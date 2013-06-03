class Organization < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Tire::Model::Search
  include Tire::Model::Callbacks
  extend FriendlyId
  extend Groupable

  mapping do
    indexes :id,                :index    => :not_analyzed
    indexes :slug,              :index    => :not_analyzed
    indexes :name,              :analyzer => 'snowball', :boost => 100
    indexes :short_description, :analyzer => 'snowball'
    indexes :description,       :analyzer => 'snowball'
    indexes :created_at,        :type => 'date', :include_in_all => false
  end

  has_many :people
  has_many :appearances, as: :guest

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
