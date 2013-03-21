class EpisodesController < ApplicationController

  def show
    @episode = Episode.where(slug: params[:id]).first or raise ActiveRecord::RecordNotFound
  end

  def counted
    @groups = Episode.counted_by(params[:category])
    @category = params[:category].titleize
  end

  def index
    @episodes = if params[:category]
      case params[:category]
      when "date"
        if params[:id] =~ /\d\d\d\d-\d\d/
          timestamp = "timestamp '#{params[:id]}-01 00:00:00'"
          Episode.visible.where("published_at between #{timestamp} and #{timestamp} + interval '1 month'")
        else
          Episode.visible.all
        end
      when "guest"
        Person.where(slug: params[:id]).first.try(:episodes) || []
      end
    else
      Episode.visible.all
    end
  end

end
