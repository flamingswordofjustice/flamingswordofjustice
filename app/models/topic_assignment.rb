class TopicAssignment < ActiveRecord::Base
  belongs_to :topic
  belongs_to :assignable, polymorphic: true
end
