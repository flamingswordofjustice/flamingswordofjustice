class HomeController < ApplicationController

  def index
    @episodes = Episode.order("published_at DESC").limit(11).all
    @latest = @episodes.shift
    @guests = Appearance.order("created_at DESC").limit(3).all.map(&:guest).uniq

    @posts = Post.order(:created_at).limit(10).all

    @content = ( @posts + @episodes ).sort_by do |o|
      o.is_a?(Episode) ? o.published_at : o.created_at
    end.reverse[0..9]
  end

  def subscribe
    # Ok to fail validations.
    Subscriber.create(params.require(:subscriber).permit(:email))
    head :ok
  end

end
