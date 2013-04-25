class NavigationLink < ActiveRecord::Base
  include Linkable::Link

  validates :title, presence: true, uniqueness: true

  belongs_to :parent_link, class_name: "NavigationLink"
  has_many :child_links, class_name: "NavigationLink", foreign_key: :parent_link_id, dependent: :destroy

  scope :root_links, where("parent_link_id IS NULL")
  scope :parent_links, root_links.where("linkable_id IS NULL AND (location IS NULL OR LOCATION = '')")

  scope :ordered_by_position,
    joins("LEFT OUTER JOIN navigation_links parent_links on parent_links.id = navigation_links.parent_link_id").
    order("CASE WHEN navigation_links.parent_link_id IS NULL THEN navigation_links.position ELSE parent_links.position END, CASE WHEN navigation_links.parent_link_id IS NULL THEN 0 ELSE 1 END, navigation_links.position")

  acts_as_list scope: :parent_link_id

  def potential_parents
    if new_record?
      self.class.parent_links
    else
      self.class.parent_links.where("id != ?", self.id)
    end
  end

  def url
    linkable_path || ( location.present? && location ) || "#"
  end

  def root_link?
    parent_link_id.blank?
  end

  def parent_link?
    root_link? && url == "#"
  end

end
