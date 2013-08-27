class PeopleController < ApplicationController

  def show
    @person = Person.find(params[:id])

    if layout.blank?
      redirect_to person_path(params[:id], params.merge(l: choose_layout))
    elsif layout == ALTERNATE
      render template: "people/alt", layout: "minimal"
    else # Standard layout
      render template: "people/show", layout: "application"
    end
  end

  def index
    @people = Person.grouped
  end

end
