class AddLinkabilityToRedirectsAndNavlinks < ActiveRecord::Migration
  class NavigationLink < ActiveRecord::Base
    belongs_to :page
    belongs_to :linkable, polymorphic: true
  end

  class Redirect < ActiveRecord::Base
    belongs_to :linkable, polymorphic: true
    scope :pointed_at, lambda {|destination|
      unless destination.is_a?(String)
        destination = Rails.application.routes.url_helpers.polymorphic_path(destination)
      end

      where(destination: destination)
    }
  end

  class Episode < ActiveRecord::Base
    belongs_to :redirect
  end

  def change
    add_column :redirects, :linkable_id, :integer
    add_column :redirects, :linkable_type, :string
    add_column :navigation_links, :linkable_id, :integer
    add_column :navigation_links, :linkable_type, :string

    add_index :redirects, [:linkable_id, :linkable_type]
    add_index :navigation_links, [:linkable_id, :linkable_type]

    NavigationLink.where("page_id IS NOT NULL").each do |link|
      link.linkable = link.page
      link.save
    end

    Episode.where("redirect_id IS NOT NULL").each do |ep|
      ep.redirect.linkable = ep
      ep.redirect.save
    end
  end
end
