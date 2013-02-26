class NavigationLink < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  validates :title, presence: true, uniqueness: true

  belongs_to :parent_link, class_name: "NavigationLink"
  has_many :child_links, class_name: "NavigationLink", foreign_key: :parent_link_id, dependent: :destroy
  belongs_to :page

  scope :root_links, where("parent_link_id IS NULL")
  scope :parent_links, root_links.where("page_id IS NULL AND (location IS NULL OR LOCATION = '')")

  scope :ordered_by_position,
    joins("LEFT OUTER JOIN navigation_links parent_links on parent_links.id = navigation_links.parent_link_id").
    order("CASE WHEN navigation_links.parent_link_id IS NULL THEN navigation_links.position ELSE parent_links.position END, navigation_links.position")

  acts_as_list scope: :parent_link

  def potential_parents
    if new_record?
      self.class.parent_links
    else
      self.class.parent_links.where("id != ?", self.id)
    end
  end

  def url
    if location.present?
      location
    elsif page.present?
      page_path(page)
    else
      "#"
    end
  end

  def root_link?
    parent_link_id.blank?
  end

  def parent_link?
    root_link? && url == "#"
  end

end
