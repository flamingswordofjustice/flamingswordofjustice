class HomeController < ApplicationController
  before_filter :touch_session, only: :index

  def index
    @episodes = Episode.visible.limit(10).all
    @guests = Appearance.order("created_at DESC").limit(10).all.map(&:guest).reject(&:nil?).uniq

    @posts = Post.order(:created_at).limit(10).all

    @content = ( @posts + @episodes ).sort_by do |o|
      o.is_a?(Episode) ? o.published_at : o.created_at
    end.reverse[0..9]
  end

  def subscribe
    subscriber = params.require(:subscriber).permit(:email)
    Subscriber.subscribe subscriber[:email]
    head :ok
  end

  def rss
    redirect_to ENV["PODCAST_URI"], status: 302
  end

  # Permanently don't show these users a modal.
  def ignore
    session[:never_show_modal] = true
    head :ok
  end

end
