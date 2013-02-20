class EpisodeImporter

  class << self
    def import(io, &block)
      Nokogiri::XML(io).xpath('//item').map do |item|
        self.new(item).attributes.tap do |attrs|
          yield attrs if block_given?
        end
      end
    end
  end

  def initialize(item)
    @item = item
  end

  def title
    @item.xpath('./title').first.content
  end

  # def episode
  #   title.match(/#\d+/)[0]
  # end

  def download_url
    @item.xpath('./enclosure').first['url']
  end

  def published_at
    DateTime.parse(@item.xpath('./pubDate').first.content)
  end

  def image
    require 'open-uri'
    url = @item.xpath('./media:thumbnail').first['url']
    open url
  end

  def libsyn_id
    @item.xpath('./guid').first.content
  end

  def description
    @item.xpath('./description').first.content
  end

  def attributes
    {
      title: title,
      download_url: download_url,
      published_at: published_at,
      # Every existing Libsyn image is just the FSJ logo.
      image: image,
      libsyn_id: libsyn_id,
      description: description
    }
  end

end
