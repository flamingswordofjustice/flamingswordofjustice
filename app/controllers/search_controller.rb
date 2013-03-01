class SearchController < ApplicationController

  def index
    @search = Tire.search('episodes,posts,people') do |s|
      s.query { |q| q.string params[:q] }
    end
    @results = @search.results
  end

end
