class Redirect < ActiveRecord::Base
  include Linkable::Link

  belongs_to :linkable, polymorphic: true

  before_save :generate_path

  def display_name
    self.path + " -> " + self.destination
  end

  scope :pointed_at, lambda {|destination|
    unless destination.is_a?(String)
      destination = Rails.application.routes.url_helpers.polymorphic_path(destination)
    end

    where(destination: destination)
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
