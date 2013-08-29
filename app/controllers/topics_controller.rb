class TopicsController < ApplicationController

  def index


    if layout == ALTERNATE
      alphabet = ("A".."Z").to_a
      groups   = alphabet.in_groups_of(3)
      @topics  = groups.inject({}) do |h, group|
        h.merge(group => [])
      end

      Topic.all.each do |t|
        index_of_letter = alphabet.index t.name.chars.first.upcase
        # Integer division rounds down and places us in the right group.
        group = groups[ index_of_letter / 3 ]
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
