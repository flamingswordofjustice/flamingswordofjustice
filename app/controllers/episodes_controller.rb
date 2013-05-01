class EpisodesController < ApplicationController

  def show
    @episode = Episode.where(slug: params[:id]).first or raise ActiveRecord::RecordNotFound

    ref = (params[:ref].present? && params[:ref] =~ /^\w+$/) ? params[:ref] : "none"
    Fsj.statsd.gauge "clicks.#{params[:id]}.#{ref}", "+1"

    respond_to do |f|
      f.html { }
      f.json { render json: @episode.to_json(only: [:title, :state, :show_notes, :description]) }
    end
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

  def email
    @episode = Episode.find(params[:id])
    render template: 'episode_mailer/published_email', layout: false
  end

  def audio
    @episode = Episode.find(params[:id])

    if @episode.unpublished?
      render text: "Episode is unpublished - no audio stream available", status: :not_found
    elsif @episode.live?
      redirect_to ENV["LIVE_BROADCAST_URI"]
    else
      redirect_to @episode.download_url
    end
  end

end
