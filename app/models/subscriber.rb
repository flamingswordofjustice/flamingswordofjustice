class Subscriber < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true

  def self.default_mailing_list
    @default_mailing_list ||= ENV["DEFAULT_MAILING_LIST"]
  end

  def self.subscribe(email)
    self.create email: email

    if Rails.env.production?
      Mailgun().list_members(default_mailing_list).add email
    end
  end
end
