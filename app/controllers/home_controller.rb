class HomeController < ApplicationController

  def index
    @shows = Show.order("recorded_at DESC").limit(11).all
    @latest = @shows.shift

    @posts = Post.order(:created_at).limit(10).all

    @content = ( @posts + @shows ).sort_by do |o|
      o.is_a?(Show) ? o.recorded_at : o.created_at
    end
  end

end
