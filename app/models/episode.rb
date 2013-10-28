class Episode < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Tire::Model::Search
  include Linkable::Subject
  extend FriendlyId
  extend Groupable

  module Players
    AUDIO = "a"
    VIDEO = "v"
    POSSIBLE_TYPES = [ AUDIO, VIDEO ]
  end

  mapping do
    indexes :id,           :index    => :not_analyzed
    indexes :slug,         :index    => :not_analyzed
    indexes :title,        :analyzer => 'snowball', :boost => 100
    indexes :headline,     :analyzer => 'snowball', :boost => 100
    indexes :description,  :analyzer => 'snowball'
    indexes :show_notes,   :analyzer => 'snowball'
    indexes :social_description, :analyzer => 'snowball'
    indexes :guests,       :analyzer => 'keyword', :as => lambda {|e| e.guests.map(&:name)}
    indexes :topics,       :analyzer => 'keyword', :as => lambda {|e| e.topics.map(&:name)}
    indexes :published_at, :type => 'date', :include_in_all => false
  end

  after_save do
    tire.update_index if published? || live?
  end

  after_destroy do
    tire.update_index
  end

  has_many :appearances
  has_many :topic_assignments, as: :assignable
  has_many :topics, through: :topic_assignments
  belongs_to :redirect
  belongs_to :host, class_name: "Person"

  def guests
    appearances.map &:guest
  end

  def guests_attributes
    polymorphic_select_list_of self.guests
  end

  def guests_attributes=(guests)
    new_appearances = guests.select(&:present?).map do |g|
      ar_class, id = g.split(':')
      self.appearances.where(guest_type: ar_class, guest_id: id.to_i).first_or_initialize
    end

    self.appearances = new_appearances
  end

  def possible_guests
    polymorphic_select_list_of ( Person.all + Organization.all ).sort_by(&:name)
  end

  def polymorphic_select_list_of(stuff)
    stuff.map {|o| ["#{o.class.name}: #{o.name}", "#{o.class.name}:#{o.id}"]}
  end

  linkable_to :navigation_links
  linkable_to :redirects

  scope :visible, where(state: [:published, :live])

  default_value_for(:published_at) { DateTime.now }
  default_value_for(:state) { :unpublished }
  default_scope { order("published_at DESC") }

  friendly_id :title, use: :slugged
  validates :title, presence: true, uniqueness: true

  mount_uploader :image, EpisodeImageUploader

  POSSIBLE_STATES = [ :published, :unpublished, :live ]

  POSSIBLE_STATES.each do |state|
    define_method("#{state}?") { self.state.to_sym == state }
  end

  def possible_states
    POSSIBLE_STATES
  end

  def default_state
    :unpublished
  end

  def visible?
    [:published, :live].include?(self.state.to_sym)
  end

  def next
    Episode.unscoped.visible
      .where("published_at > ?", self.published_at)
      .order("published_at ASC").first
  end

  def prev
    Episode.visible.where("published_at < ?", self.published_at).first
  end

  def groupable_by
    self.published_at.strftime("%B %Y")
  end

  def display_name; self.title; end

  def default_twitter_text
    if self.twitter_text.present?
      self.twitter_text
    elsif self.headline.present?
      self.headline
    else
      self.title + " - " + I18n.t(:tag)
    end
  end

  def canonical_short_link
    if self.redirect.present?
      self.redirect.url
    elsif redirect = Redirect.pointed_at(self).first
      update_attributes redirect: redirect
      redirect.url
    end
  end

  def audio_filename
    "#{I18n.t('abbrev')}-#{self.slug}.mp3"
  end

  def has_video?
    self.youtube_video_id.present?
  end

  def has_audio?
    self.download_url.present?
  end

  def supports_both_play_types?
    has_video? && has_audio?
  end

  def possible_player_types
    [].tap do |a|
      a << Episode::Players::AUDIO if has_audio?
      a << Episode::Players::VIDEO if has_video?
    end
  end

  def page_headline
    self.headline.present? ? self.headline : self.title
  end

  def sub_headline
    self.headline.present? ? self.title : I18n.t(:tag)
  end

  def related
    Episode
      .where("episodes.id != ?", self.id)
      .where("topics.id IN (?)", self.topics.select("topics.id").map(&:id))
      .joins(:topics)
      .group("episodes.id")
      .order("random()")
      .limit(2)
  end

  class << self
    def possible_years
      results = self.connection.select_all <<-SQL
        SELECT EXTRACT(YEAR FROM published_at) AS year
        FROM #{self.table_name}
        GROUP BY year
      SQL

      results.map {|r| r['year']}
    end

    def grouped_by(category)
      if respond_to?("grouped_by_#{category}")
        send "grouped_by_#{category}"
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    def grouped_by_date
      Episode.visible.grouped
    end

    def grouped_by_guest
      Person.with_episodes.grouped
    end

    def grouped_by_organization
      Organization.with_episodes.grouped
    end

    def grouped_by_topic
      Topic.with_episodes.grouped
    end

    def default_host
      @default_host ||= Person.where(name: ENV["DEFAULT_HOST"]).first
    end
  end
end
