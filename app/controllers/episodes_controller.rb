class EpisodesController < ApplicationController

  def show
    @episode = Episode.where(slug: params[:id]).first or raise ActiveRecord::RecordNotFound
  end

  def latest
    @episode = Episode.visible.first
    redirect_to episode_path(@episode)
  end

  def grouped
    @groups = Episode.grouped_by(params[:category])
    @category = params[:category]
  end

  def index
    @episodes = Episode.visible.all
  end

end
