class PostsController < ApplicationController

  def show
    @post = Post.where(slug: params[:id]).first or raise ActiveRecord::RecordNotFound

    render template: "posts/alt", layout: "minimal"
  end

end
