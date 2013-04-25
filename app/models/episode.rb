class Episode < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Tire::Model::Search
  include Linkable::Subject
  extend FriendlyId
  extend Groupable

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

  after_save do
    tire.update_index if published? || live?
  end

  after_destroy do
    tire.update_index
  end

  has_many :appearances
  has_many :guests, through: :appearances
  has_many :topic_assignments, as: :assignable
  has_many :topics, through: :topic_assignments
  belongs_to :redirect

  linkable_to :navigation_links
  linkable_to :redirects

  scope :visible, where(state: [:published, :live])

  default_value_for(:published_at) { DateTime.now }
  default_value_for(:state) { :unpublished }
  default_scope { order("published_at DESC") }

  friendly_id :title, use: :slugged
  validates :title, presence: true

  mount_uploader :image, ImageUploader

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

  def playable_url
    if unpublished?
      ""
    elsif live?
      ENV["LIVE_BROADCAST_URI"]
    else
      self.download_url
    end
  end

  def visible?
    [:published, :live].include?(self.state.to_sym)
  end

  def next
    Episode.unscoped.visible.where("published_at > ?", self.published_at).order("published_at ASC").first
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

  class << self
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
  end
end
