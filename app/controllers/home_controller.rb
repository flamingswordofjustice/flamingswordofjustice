class HomeController < ApplicationController

  def index
    @episodes = Episode.order("published_at DESC").limit(11).all
    @latest = @episodes.shift
    @guests = Guest.order("created_at DESC").limit(3).all

    @posts = Post.order(:created_at).limit(10).all

    @content = ( @posts + @episodes ).sort_by do |o|
      o.is_a?(Episode) ? o.published_at : o.created_at
    end
  end

end
