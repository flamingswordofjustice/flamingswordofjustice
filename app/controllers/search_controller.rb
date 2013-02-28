class SearchController < ApplicationController

  def index
    @results = Tire.search do |s|
      s.query { |q| q.string params[:q] }
    end.results
  end

end
