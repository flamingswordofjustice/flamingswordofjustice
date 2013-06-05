class AddHostToEpisodes < ActiveRecord::Migration
  class Person < ActiveRecord::Base; end

  class Episode < ActiveRecord::Base
    def self.default_host
      @default_host ||= Person.where(name: ENV["DEFAULT_HOST"]).first
    end
  end

  def change
    add_column :episodes, :host_id, :integer
    Episode.update_all host_id: Episode.default_host.try(:id)
  end
end
