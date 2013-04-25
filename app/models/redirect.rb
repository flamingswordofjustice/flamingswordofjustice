class Redirect < ActiveRecord::Base
  include Linkable::Link

  belongs_to :linkable, polymorphic: true

  before_save :generate_path

  def display_name
    self.path + " -> " + self.destination
  end

  scope :pointed_at, lambda {|destination|
    if destination.is_a?(String)
      where(destination: destination)
    else
      path = Rails.application.routes.url_helpers.polymorphic_path(destination)
      where("destination = ? OR (linkable_id = ? AND linkable_type = ?)", path, destination.id, destination.class.name)
    end
  }

  def url
    "http://fsj.fm/#{self.path}"
  end

  def desination_url
    linkable_path || destination
  end

  private

  def generate_path
    if self.path.blank?
      self.path = SecureRandom.urlsafe_base64(8)
    end
  end

end
