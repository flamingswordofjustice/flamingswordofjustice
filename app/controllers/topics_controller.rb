class TopicsController < ApplicationController

  def index
    @topics = Topic.grouped
  end

  def show
    @topic = Topic.find(params[:id])

    if layout == ALTERNATE
      render template: "topics/alt", layout: "minimal"
    else # Standard layout
      render template: "topics/show", layout: "application"
    end
  end

end
