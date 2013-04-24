class Redirect < ActiveRecord::Base

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

  def full_url
    "http://fsj.fm/#{self.path}"
  end

  private

  def generate_path
    if self.path.blank?
      self.path = SecureRandom.urlsafe_base64(8)
    end
  end

end
