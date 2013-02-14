class Post < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  extend FriendlyId

  belongs_to :author, class_name: "User"
  friendly_id :title, use: :slugged

  validates :title, :content, presence: true
  validates :author_id, presence: true

  def author_name
    author.name || author.email.split("@").first
  end
end
