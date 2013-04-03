class TopicsController < ApplicationController

  def index
    @topics = Topic.grouped
  end

  def show
    @topic = Topic.find(params[:id])
  end

end
