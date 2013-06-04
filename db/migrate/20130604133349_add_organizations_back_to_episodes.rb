class AddOrganizationsBackToEpisodes < ActiveRecord::Migration
  def change
    Episode.all.each do |e|
      orgs = e.appearances.map(&:guest).map do |g|
        g.respond_to?(:organization) && g.organization
      end.reject(&:blank?).uniq

      orgs.each do |org|
        e.appearances.create guest: org
      end
    end
  end
end
