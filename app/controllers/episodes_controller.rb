class EpisodesController < ApplicationController
  before_filter :touch_session, only: :show

  DEFAULT_PER_PAGE = 10

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
        render template: "episodes/alt", layout: "minimal"
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
    page = params[:page]     || 1
    per  = params[:per_page] || DEFAULT_PER_PAGE

    @episodes = Episode.visible.page(page).per(per)
    @filters  = ( params[:f] || "" ).split(",")

    render template: "episodes/alt_index", layout: "minimal"
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

  # Specific to AJAX requests for whole episodes.
  def rest
    episodes = Episode.visible.offset(params[:offset] || DEFAULT_PER_PAGE).all
    list = render_to_string partial: "episodes/mixed", collection: episodes

    render json: { episodes: list }
  end

end
