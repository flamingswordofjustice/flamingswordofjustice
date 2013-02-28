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
      search = Episode.tire.search { facet('timeline') { date :published_at, :interval => 'month' } }
      times = search.facets["timeline"]["entries"]
      times.map do |t|
        date = Time.zone.at(t['time'] / 1000)
        count = t['count']
        OpenStruct.new(model: date, label: date.strftime("%B %Y"), id: date.strftime("%Y-%m"), category: 'date', count: count)
      end
    end

    def counted_by_guest
      Person.where("appearances_count > 0").order("appearances_count DESC").map do |p|
        OpenStruct.new(model: p, label: p.name, id: p.slug, category: 'guest', count: p.appearances_count)
      end
    end
  end
end
