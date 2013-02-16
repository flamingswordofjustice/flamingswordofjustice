require 'spec_helper'

describe EpisodeImporter do
  let(:io) { Rails.root.join("spec", "fixtures", "rss.xml").open }
  before(:all) { @imports = RssImporter.import(io) }
  subject { @imports.first }

  describe "import" do
    its(:title) { should == "#14 Team Franken" }
    its(:download_url) { should == "http://traffic.libsyn.com/flamingswordofjustice/Sword_2012_05_06.mp3" }
    its(:published_at) { should == DateTime.parse("Sat, 05 May 2012 22:41:03 +0000") }
    its(:libsyn_id) { should == "15c3468b413346f71e671e142d94d048" }
    its(:description) { should match(/Andy Barr tells the story of working with Al Franken/) }
  end

  specify { @imports.length.should == 14 }
end
