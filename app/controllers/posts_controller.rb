class PostsController < ApplicationController

  def show
    @post = Post.where(slug: params[:id]).first or raise ActiveRecord::RecordNotFound
    @canonical_fb_url = post_url(id: @post.slug, ref: params[:ref] || "fb", protocol: "http", l: layout)

    if layout == ALTERNATE
      render template: "posts/alt", layout: "minimal"
    else # Standard layout
      render template: "posts/show", layout: "application"
    end
  end

end
