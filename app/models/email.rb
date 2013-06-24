class Email < ActiveRecord::Base
  RECIPIENT_BLACKLIST = [
    "daily@flamingswordofjustice.com"
  ]

  belongs_to :episode
  belongs_to :proofed_by, class_name: "User"

  validates :subject, :body, presence: { if: lambda { |e| e.episode_id.blank? } }

  def renderer
    ApplicationController.new
  end

  def proofed?
    self.proofed_at.present?
  end

  def email_template
    if self.episode.present?
      'emails/episode'
    else
      'emails/generic'
    end
  end

  def send!
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
  end

  def proof!
    self.proofed_at = Time.now

    mailer.send_email(
      to:      ENV['EMAIL_TEST_RECIPIENT'],
      from:    self.sender,
      subject: self.proof_subject,
      html:    self.html
    )
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

  def raw_content
    renderer.render_to_string template: email_template, layout: false, locals: { episode: self.episode }
  end

  def mailer
    self.stub_mailer || Mailgun().messages
  end


end
