class HomeController < ApplicationController
  before_filter :touch_session, only: :index

  def index
    @episodes = Episode.visible.limit(11).all
    @latest = @episodes.shift
    @guests = Appearance.order("created_at DESC").limit(10).all.map(&:guest).uniq

    @posts = Post.order(:created_at).limit(10).all

    @content = ( @posts + @episodes ).sort_by do |o|
      o.is_a?(Episode) ? o.published_at : o.created_at
    end.reverse[0..9]
  end

  def subscribe
    subscriber = params.require(:subscriber).permit(:email)

    unless Rails.env.development?
      Subscriber.subscribe subscriber[:email]
    end

    head :ok
  end

end
