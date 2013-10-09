class PagesController < ApplicationController

  def show
    @page = Page.find(params[:page])
    not_found if @page.nil?
    render template: "pages/alt", layout: "minimal"
  end

end
