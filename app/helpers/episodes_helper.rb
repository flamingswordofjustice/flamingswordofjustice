module EpisodesHelper
  def player_data_for(episode)
    {
      "mp3-uri"      => audio_episode_url(episode),
      "tracking-uri" => listener_tracking_uri,
      "swf-path"     => asset_path("Jplayer.swf", type: "flash"),
      "user-session" => session[:session_id],
      "play-session" => SecureRandom.urlsafe_base64
    }
  end

  def player_url_for(episode)
    image_url = asset_paths.is_uri?(episode.image.url) ?
      episode.image.url :
      "http://" + request.host_with_port + episode.image.url

    params = {
      mp3:       audio_episode_url(episode),
      userId:    session[:session_id],
      image:     image_url,
      caption:   episode.image_caption,
      episodeId: episode.slug
    }

    "http://localhost:5000/player?" + params.to_param
  end

  def youtube_player(id, attrs={})
    elt_id = attrs[:id] || "youtube-placeholder"
    content_tag "div", "", "id" => elt_id, "class" => "youtube-placeholder", "data-youtube-id" => id
  end
end
