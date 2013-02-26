class Topic < ActiveRecord::Base
  extend FriendlyId

  has_many :topic_assignments

  validates :name, uniqueness: true

  def assignables
    topic_assignments.includes(:assignable).map &:assignable
  end

  friendly_id :name, use: :slugged
end
