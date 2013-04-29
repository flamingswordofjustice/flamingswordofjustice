class EpisodeImageUploader < ImageUploader
  version :bw do
    process :grayscale
  end

  version :playable do
    process :composite_play_button
  end

  def grayscale
    manipulate! { |img| img.colorspace "gray"; img }
  end

  def composite_play_button
    manipulate! do |img|
      play_path = Rails.root.join("app", "assets", "images", "play-button.png").to_s
      play_button = MiniMagick::Image.open(play_path, "jpg")
      img = img.composite(play_button) { |i| i.gravity "center" }
      img
    end
  end
end
