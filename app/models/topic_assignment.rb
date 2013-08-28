class TopicAssignment < ActiveRecord::Base
  belongs_to :topic
  belongs_to :assignable, polymorphic: true
  scope :episodes, lambda { where(assignable_type: Episode.name) }
end
