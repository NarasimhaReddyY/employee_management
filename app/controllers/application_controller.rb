class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from ::Errors::InvalidLink, with: :invalid_link

  def invalid_link
    render 'errors/link_expired', layout: false
  end
end
