class Page < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Linkable::Subject
  extend FriendlyId

  linkable_to :navigation_links
  linkable_to :redirects

  friendly_id :title, use: :slugged
end
