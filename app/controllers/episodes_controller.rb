class EpisodesController < ApplicationController
  before_filter :touch_session, only: :show

  def show
    @modal_enabled = true

    @modal_enabled = if session[:never_show_modal].present?
      false
    elsif session[:modal_shown_at].present?
      session[:modal_shown_at] < 24.hours.ago
    else
      [ true, false ][ rand(2) ]
    end

    if @modal_enabled
      session[:modal_shown_at] = DateTime.now
    end

    @episode = if params[:id] =~ /^\d+$/
      Episode.find(params[:id])
    else
      Episode.where(slug: params[:id]).first or raise ActiveRecord::RecordNotFound
    end

    respond_to do |f|
      f.html do
        layout = params[:l]

        if layout.blank?
          redirect_to episode_path(params[:id], params.merge(l: choose_layout))
        elsif layout == ALTERNATE
          render template: "episodes/alt", layout: "minimal"
        else # Standard layout
          render template: "episodes/show", layout: "application"
        end
      end

      f.json do
        render json: @episode.attributes.slice(
          "title", "state", "show_notes", "description", "headline"
        ).merge(
          "id" => @episode.slug,
          "permalink" => episode_url(@episode)
        ).to_json
      end
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

    if layout == ALTERNATE
      render template: "episodes/alt_index", layout: "minimal"
    else # Standard layout
      render template: "episodes/index", layout: "application"
    end
  end

  def email
    # Maintained for backwards compatibility with old emails.
    episode = Episode.where(slug: params[:id]).first
    email = Email.where(episode_id: episode.id).first
    render text: email.html, content_type: "text/html"
  end

  def audio
    @episode = Episode.find(params[:id])
    response.header['Content-Disposition'] = "attachment; filename=#{@episode.audio_filename}"

    if @episode.unpublished?
      render text: "Episode is unpublished - no audio stream available", status: :not_found
    elsif @episode.live?
      redirect_to ENV["LIVE_BROADCAST_URI"]
    else
      redirect_to @episode.download_url
    end
  end


end
