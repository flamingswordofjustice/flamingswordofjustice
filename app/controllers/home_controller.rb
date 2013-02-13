class HomeController < ApplicationController

  def index
    @shows = Show.order(:recorded_at).limit(10).all
  end

end
