class EpisodesController < ApplicationController

  def show
    @episode = Episode.find(params[:id])
  end

  def counted
    @search = Episode.counted_by(params[:category])
  end

  def index
    @episodes = if params[:category]
      case params[:category]
      when "date"
        if params[:id] =~ /\d\d\d\d-\d\d/
          timestamp = "timestamp '#{params[:id]}-01 00:00:00'"
          Episode.where("published_at between #{timestamp} and #{timestamp} + interval '1 month'")
        else
          Episode.all
        end
      when "guest"
        Person.where(slug: params[:id]).first.try(:episodes) || []
      end
    else
      Episode.all
    end
  end

end
