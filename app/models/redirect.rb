class Redirect < ActiveRecord::Base

  before_save :generate_path

  private

  def generate_path
    if self.path.blank?
      self.path = SecureRandom.urlsafe_base64(8)
    end
  end

end
