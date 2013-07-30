module EpisodesHelper
  def player_data_for(episode)
    {
      "mp3-uri"      => audio_episode_url(episode),
      "tracking-uri" => listener_tracking_uri,
      # "swf-path"     => asset_path("vendor/Jplayer.swf"),
      "user-session" => session[:session_id],
      "play-session" => SecureRandom.urlsafe_base64
    }
  end

  def youtube_player(id, attrs={})
    elt_id = attrs[:id] || "youtube-placeholder"
    content_tag "div", "", "id" => elt_id, "class" => "youtube-placeholder", "data-youtube-id" => id
  end
end
