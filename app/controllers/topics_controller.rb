class TopicsController < ApplicationController

  def index
    if layout == ALTERNATE
      n = 4
      alphabet = ("A".."Z").to_a
      groups   = [ ("0".."9").to_a ] + alphabet.in_groups_of(n)
      @topics  = groups.inject({}) do |h, group|
        h.merge(group.compact => [])
      end

      Topic.all.each do |t|
        index_of_letter = alphabet.index t.name.chars.first.upcase
        index_of_group  = index_of_letter.nil? ? 0 : (index_of_letter / n) + 1
        group = groups[ index_of_group ]
        @topics[group].push t
      end

      render template: "topics/alt_index", layout: "minimal"
    else # Standard layout
      @topics = Topic.grouped
      render template: "topics/index", layout: "application"
    end
  end

  def show
    @topic = Topic.find(params[:id])

    if layout == ALTERNATE
      render template: "topics/alt", layout: "minimal"
    else # Standard layout
      render template: "topics/show", layout: "application"
    end
  end

end
