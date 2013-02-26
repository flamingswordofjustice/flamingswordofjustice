class Post < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Tire::Model::Search
  include Tire::Model::Callbacks
  extend FriendlyId

  mapping do
    indexes :id,           :index    => :not_analyzed
    indexes :title,        :analyzer => 'snowball', :boost => 100
    indexes :content,      :analyzer => 'snowball'
    indexes :content_size, :as       => 'content.size'
    indexes :author,       :analyzer => 'keyword'
    indexes :tags,         :analyzer => 'keyword'
    indexes :created_at, :type => 'date', :include_in_all => false
  end

  belongs_to :author, class_name: "User"
  has_many :topic_assignments, as: :assignable
  has_many :topics, through: :topic_assignments

  friendly_id :title, use: :slugged

  validates :title, :content, presence: true
  validates :author_id, presence: true


  def author_name
    author.name || author.email.split("@").first
  end
end
