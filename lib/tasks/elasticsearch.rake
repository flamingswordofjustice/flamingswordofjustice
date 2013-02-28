# https://gist.github.com/mahemoff/3751744/raw/7bd7f5e1f0d09ddb6064f03cf38a66a9da34f9f6/elasticsearch.rake
# Run with: rake environment elasticsearch:reindex
# Begins by creating the index using tire:import command. This will create the "official" index name, e.g. "person" each time.
# Then we rename it to, e.g. "person20121001" and alias "person" to it.

namespace :elasticsearch do
  desc "re-index elasticsearch"
  task :reindex => :environment do

    model_classes = ActiveRecord::Base.subclasses.select {|c| c.respond_to?(:tire)}

    model_classes.each do |model_class|
      puts "::::::: #{model_class} :::::::::\n"

      ENV['CLASS'] = model_class.name
      ENV['INDEX'] = new_index = model_class.tire.index.name << '_' << Time.now.strftime('%Y%m%d%H%M%S')
      puts "New index #{new_index}"

      Rake::Task["tire:import"].execute("CLASS='#{model_class}'")

      puts '[IMPORT] about to swap index'
      if a = Tire::Alias.find(model_class.tire.index.name)
        puts "[IMPORT] aliases found: #{Tire::Alias.find(model_class.tire.index.name).indices.to_ary.join(',')}. deleting."
        old_indices = Tire::Alias.find(model_class.tire.index.name).indices
        old_indices.each do |index|
          a.indices.delete index
        end

        a.indices.add new_index
        a.save

        old_indices.each do |index|
          puts "[IMPORT] deleting index: #{index}"
          i = Tire::Index.new(index)
          i.delete if i.exists?
        end
      else
        puts "[IMPORT] no aliases found. deleting index. creating new one and setting up alias."
        model_class.tire.index.delete

        a = Tire::Alias.new
        a.name(model_class.tire.index.name)
        a.index(new_index)
        a.save

        puts "Saved alias #{model_class.tire.index.name} pointing to #{new_index}"
      end

      puts "[IMPORT] done. Index: '#{new_index}' created."
    end

  end

end
