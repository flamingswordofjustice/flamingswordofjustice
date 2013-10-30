class Email < ActiveRecord::Base
  RECIPIENT_BLACKLIST = [
    "daily@thegoodfight.fm",
    "daily@flamingswordofjustice.com"
  ]

  belongs_to :episode
  belongs_to :proofed_by, class_name: "User"
  validates_presence_of :subject, :sender, :recipient
  attr_accessor :stub_mailer # For tests only.

  validates :subject, :body, presence: { if: lambda { |e| e.episode_id.blank? } }

  def renderer(request)
    host = request.nil? ? ActionMailer::Base.default_url_options[:host] : request.host

    Class.new(ApplicationController) do
      def initialize(host); @host = host; end

      def url_options
        { protocol: "http", host: @host }
      end
    end.new(host).tap {|c| c.request = request }
  end

  def proofed?
    self.proofed_at.present?
  end

  def sent?
    self.sent_at.present?
  end

  def email_template
    if self.episode.present?
      'emails/episode'
    else
      'emails/generic'
    end
  end

  def send!(user)
    raise "Not proofed" if !self.proofed?
    raise "Not sent"    if Rails.env.development? && RECIPIENT_BLACKLIST.include?(self.recipient)

    mailer.send_email(
      to:      self.recipient,
      from:    self.sender,
      subject: self.subject,
      html:    self.html
    )

    self.update_attributes proofed_by: user, sent_at: Time.now
  end

  def proof!
    mailer.send_email(
      to:      self.proof_recipient,
      from:    self.sender,
      subject: self.proof_subject,
      html:    self.html
    )

    self.update_attributes proofed_at: Time.now
  end

  def html(host=nil)
    Premailer.new(raw_content(host),
      with_html_string: true,
      input_encoding: "UTF-8"
    ).to_inline_css
  end

  def proof_subject
    "[PROOF] #{subject}"
  end

  def proof_recipient
    ENV['EMAIL_TEST_RECIPIENT']
  end

  def raw_content(host)
    renderer(host).render_to_string(
      template: email_template,
      layout: false,
      locals: { email: self, episode: self.episode }
    )
  end

  def mailer
    self.stub_mailer || Mailgun().messages
  end


end
