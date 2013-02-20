task :episode_sync => :environment do
  require 'open-uri'
  podcasts = open(ENV["PODCAST_URI"])
  should_overwrite = ENV["OVERWRITE"].present?

  EpisodeImporter.import(podcasts).each do |attributes|
    episode = if Episode.exists?(attributes.slice(:libsyn_id))
      Episode.where(attributes.slice(:libsyn_id)).first
    else
      Episode.new(attributes)
    end

    if episode.new_record?
      if episode.save
        puts "Imported #{model.title}"
      else
        puts "Failed #{episode.title}: #{model.errors.full_messages.join(';')}"
      end
    elsif should_overwrite
      episode.attributes = attributes
      if episode.save
        puts "Overwrote #{episode.title}"
      else
        puts "Failed #{episode.title}: #{model.errors.full_messages.join(';')}"
      end
    else
      puts "Skipping #{episode.title}; already exists"
    end
  end
end
