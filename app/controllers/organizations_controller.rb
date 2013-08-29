class OrganizationsController < ApplicationController

  def show
    @organization = Organization.find(params[:id])

    if layout == ALTERNATE
      render template: "organizations/alt", layout: "minimal"
    else # Standard layout
      render template: "organizations/show", layout: "application"
    end
  end

  def index
    @organizations = Organization.grouped
  end

end
