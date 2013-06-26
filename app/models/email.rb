class Email < ActiveRecord::Base
  RECIPIENT_BLACKLIST = [
    "daily@flamingswordofjustice.com"
  ]

  belongs_to :episode
  belongs_to :proofed_by, class_name: "User"
  validates_presence_of :subject, :sender, :recipient
  attr_accessor :stub_mailer # For tests only.

  validates :subject, :body, presence: { if: lambda { |e| e.episode_id.blank? } }

  def renderer
    Class.new(ApplicationController) do
      def url_options
        {
          protocol: "http",
          host: ActionMailer::Base.default_url_options[:host]
        }
      end
    end.new
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
    raise "Not proofed" unless self.proofed?

    if RECIPIENT_BLACKLIST.include?(self.recipient)
      raise "Not sent" if Rails.env.development? || !episode.proofed?
    end

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

  def html
    Premailer.new(raw_content,
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

  def raw_content
    renderer.render_to_string(
      template: email_template,
      layout: false,
      locals: { email: self, episode: self.episode }
    )
  end

  def mailer
    self.stub_mailer || Mailgun().messages
  end


end
