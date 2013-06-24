describe Email do
  # class FakeRenderer
  #   def initialize(content); @content = content; end
  #   def render_to_string(*args); @content; end
  # end

  # class FakeMailer
  #   def send_email(attrs); @request = attrs; end
  #   def request; OpenStruct.new(@request || {}); end
  # end

  # context "html" do
  #   let(:renderer) do
  #     FakeRenderer.new <<-HTML
  #       <html>
  #         <head><style type="text/css">.default { font-size: 14px; }</style></head>
  #         <body><div class="default">–</div></body>
  #       </html>
  #     HTML
  #   end

  #   let(:episode) { build(:episode) }
  #   let(:html)    { Nokogiri::HTML.parse(email.html) }
  #   let(:email)   { Email.new(renderer: renderer, stub_mailer: FakeMailer.new) }
  #   before { Episode.stub(:where).and_return [ episode ] }

  #   it("inlines styles")  { html.search('div').first['style'].should eq("font-size: 14px;") }
  #   it("sets an episode") { email.html; renderer.instance_variable_get("@episode").should eq(episode) }
  #   it("parses UTF-8")    { html.search('div').first.text.should eq("–") }
  # end

  # context "subject" do
  #   subject { Email.new }
  #   before { Episode.stub(:where).and_return [ episode ] }

  #   context "prefers a headline" do
  #     let(:episode) { stub_model(Episode, title: "A title!", headline: "A headline!", proofed?: true) }
  #     its(:subject) { should eq("A headline!") }
  #   end

  #   context "with only a title" do
  #     let(:episode) { stub_model(Episode, title: "A title!", proofed?: true) }
  #     its(:subject) { should eq("A title!") }
  #   end

  #   context "not yet proofed" do
  #     let(:episode) { stub_model(Episode, title: "A title!", proofed?: false) }
  #     its(:subject) { should eq("[PROOF] A title!") }
  #   end
  # end

  # context "send!" do
  #   let(:mailer)      { FakeMailer.new }
  #   let(:renderer)    { FakeRenderer.new("") }
  #   let(:episode)     { stub_model(Episode) }
  #   let(:blacklisted) { Email::RECIPIENT_BLACKLIST.first }
  #   let(:innocent)    { "text@example.com" }

  #   before { Episode.stub(:where).and_return [ episode ] }

  #   context "proofing" do
  #     context "fails if no user given" do
  #       subject { Email.new(proofed: true, stub_mailer: mailer, renderer: renderer) }
  #       specify { expect { subject.send! }.to raise_error(/No user/) }
  #     end

  #     context "is successful if user given" do
  #       before  { episode.should_receive(:proof!) }
  #       subject { Email.new(proofed: true, admin_user: stub_model(User), stub_mailer: mailer, renderer: renderer) }
  #       specify { subject.send! }
  #     end
  #   end

  #   context "blacklisting" do
  #     context "prevents sending in development mode" do
  #       before  { Rails.env.stub!(:development?).and_return true }
  #       subject { Email.new(recipient: blacklisted) }
  #       specify { expect { subject.send! }.to raise_error(/Not sent/) }
  #     end

  #     context "prevents sending if episode unproofed" do
  #       let(:episode) { stub_model(Episode, proofed?: false) }
  #       before  { Rails.env.stub!(:development?).and_return false }
  #       subject { Email.new(recipient: blacklisted) }
  #       specify { expect { subject.send! }.to raise_error(/Not sent/) }
  #     end
  #   end

  #   context "when successful" do
  #     let(:episode)  { stub_model(Episode, proofed?: true, headline: "Open this email!") }
  #     let(:renderer) { FakeRenderer.new("The episode!") }
  #     let(:email)    { Email.new(stub_mailer: mailer, renderer: renderer, recipient: innocent, sender: "show@example.com") }

  #     before  { email.send! }
  #     subject { mailer.request }

  #     its(:to)      { should eq(innocent) }
  #     its(:from)    { should eq("show@example.com") }
  #     its(:subject) { should eq("Open this email!") }
  #     its(:html)    { should match(/The episode!/) }
  #   end
  # end

end
