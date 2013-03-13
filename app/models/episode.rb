class Episode < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Tire::Model::Search
  include Tire::Model::Callbacks
  extend FriendlyId

  mapping do
    indexes :id,           :index    => :not_analyzed
    indexes :slug,         :index    => :not_analyzed
    indexes :title,        :analyzer => 'snowball', :boost => 100
    indexes :description,  :analyzer => 'snowball'
    indexes :notes,        :analyzer => 'snowball'
    indexes :guests,       :analyzer => 'keyword', :as => lambda {|e| e.guests.map(&:name)}
    indexes :topics,       :analyzer => 'keyword', :as => lambda {|e| e.topics.map(&:name)}
    indexes :published_at, :type => 'date', :include_in_all => false
  end

  has_many :appearances
  has_many :guests, through: :appearances
  has_many :topic_assignments, as: :assignable
  has_many :topics, through: :topic_assignments

  default_value_for(:published_at) { DateTime.now }
  default_scope { order("published_at DESC") }

  friendly_id :title, use: :slugged
  validates :title, presence: true
  validates :libsyn_id, uniqueness: true

  mount_uploader :image, ImageUploader

  class << self
    def counted_by(category)
      if respond_to?("counted_by_#{category}")
        send "counted_by_#{category}"
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    def counted_by_date
      Episode.order("published_at DESC").group_by do |episode|
        episode.published_at.strftime("%B %Y")
      end
    end

    def counted_by_guest
      Person.where("appearances_count > 0").order("name ASC").group_by do |person|
        person.name.chars.first
      end
    end

    def counted_by_organization
      Organization.joins(:people).order("name ASC").group("organizations.id").having("sum(people.appearances_count) > 0").group_by do |organization|
        organization.name.chars.first
      end
    end

    def counted_by_topic
      Topic.joins(:topic_assignments).order("name ASC").group("topics.id").where("topic_assignments.assignable_type = ?", Episode.name).having("count(topic_assignments.id) > 0").group_by do |topic|
        topic.name.chars.first
      end
    end
  end
end
