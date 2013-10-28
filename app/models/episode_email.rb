class EpisodeEmail
  include ActiveAttr::Model

  attribute :id,         type: String
  attribute :recipient,  type: String
  attribute :sender,     type: String
  attribute :proofed,    type: Boolean
  attribute :admin_user
  attribute :renderer
  attribute :stub_mailer

  EMAIL_TEMPLATE = 'episode_mailer/published_email'

  RECIPIENT_BLACKLIST = [
    "daily@flamingswordofjustice.com",
    "daily@thegoodfight.fm"
  ]

  alias_method :proofed?, :proofed

  def send!
    if self.proofed?
      raise "No user provided" if self.admin_user.blank?
      episode.proof! admin_user
    end

    if RECIPIENT_BLACKLIST.include?(self.recipient)
      raise "Not sent" if Rails.env.development? || !episode.proofed?
    end

    mailer.send_email(
      to:      self.recipient,
      subject: self.subject,
      html:    self.html,
      from:    self.sender
    )
  end

  def html
    Premailer.new(raw_content,
      with_html_string: true,
      input_encoding: "UTF-8"
    ).to_inline_css
  end

  def subject
    subject = episode.headline.present? ? episode.headline : episode.title
    subject = "[PROOF] #{subject}" unless episode.proofed?
    subject
  end

  def episode
    Episode.where(slug: self.id).first
  end

  def raw_content
    renderer.send :instance_variable_set, "@episode", self.episode
    renderer.render_to_string template: EMAIL_TEMPLATE, layout: false
  end

  def mailer
    self.stub_mailer || Mailgun().messages
  end
end
