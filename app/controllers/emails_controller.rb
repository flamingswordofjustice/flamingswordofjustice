class EmailsController < ApplicationController

  def show
    email = Email.find(params[:id])
    render text: email.html(request), content_type: "text/html"
  end

end
