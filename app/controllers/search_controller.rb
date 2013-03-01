class SearchController < ApplicationController

  def index
    @results = Tire.search('episodes,posts,people') do |s|
      s.query { |q| q.string params[:q] }
    end.results
  end

end
