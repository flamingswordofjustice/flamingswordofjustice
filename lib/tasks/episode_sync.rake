task :episode_sync => :environment do
  require 'open-uri'
  podcasts = open(ENV["PODCAST_URI"])
  EpisodeImporter.import(podcasts).each do |model|
    if model.valid?
      puts "Importing #{model.title}"
      model.save
    else
      puts "Skipping #{model.title}: #{model.errors.full_messages.join(';')}"
    end
  end
end
