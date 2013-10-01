class PeopleController < ApplicationController

  def show
    @person = Person.find(params[:id])

    render template: "people/alt", layout: "minimal"
  end

  def index
    @people = Person.grouped
  end

end
