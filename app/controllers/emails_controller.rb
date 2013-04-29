class EmailsController < ApplicationController

  def show
    @episode = Episode.find(params[:id])
    render template: 'episode_mailer/published_email', layout: false
  end

end
