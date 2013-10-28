class PeopleController < ApplicationController

  def show
    @person = Person.find(params[:id])
  end

  def index
    @people = Person.grouped
  end

end
