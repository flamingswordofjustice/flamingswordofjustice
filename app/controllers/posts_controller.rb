class PostsController < ApplicationController

  def show
    @post = Post.where(slug: params[:id]).first or raise ActiveRecord::RecordNotFound
  end

end
