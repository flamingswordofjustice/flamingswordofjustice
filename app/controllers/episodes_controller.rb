class EpisodesController < ApplicationController
  before_filter :touch_session, only: :show

  def show
    @episode = if params[:id] =~ /^\d+$/
      Episode.find(params[:id])
    else
      Episode.where(slug: params[:id]).first or raise ActiveRecord::RecordNotFound
    end

    respond_to do |f|
      f.html do
        layout = params[:l]

        if layout.blank?
          redirect_to episode_path(params[:id], l: choose_layout)
        elsif layout == ALTERNATE
          render template: "episodes/alt", layout: "minimal"
        else # Standard layout
          render template: "episodes/show", layout: "application"
        end

        @canonical_fb_url = episode_url(id: @episode.slug, ref: params[:ref] || "fb", protocol: "http", l: layout)
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

  private

  STANDARD = "s"
  ALTERNATE = "a"

  def choose_layout
    if ENV["RANDOMIZE_LAYOUT"]
      [STANDARD, ALTERNATE][ rand(2) ]
    else
      ALTERNATE
    end
  end

end
