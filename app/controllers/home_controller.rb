class HomeController < ApplicationController

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
      begin
        Gibbon.new(ENV["MAILCHIMP_API_KEY"]).list_subscribe(
          id: ENV["MAILCHIMP_LIST_ID"],
          email_address: subscriber["email"]
        )
      rescue => e
        # Ok to fail validations.
        logger.info e.message
      end
    end

    Subscriber.create subscriber
    head :ok
  end

end
