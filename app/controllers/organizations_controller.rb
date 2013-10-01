class OrganizationsController < ApplicationController

  def show
    @organization = Organization.find(params[:id])

    render template: "organizations/alt", layout: "minimal"
  end

  def index
    @organizations = Organization.grouped
  end

end
