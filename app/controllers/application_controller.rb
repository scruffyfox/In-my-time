require 'json'

class ApplicationController < ActionController::Base
  protect_from_forgery

  def render_404(exception = nil)
    if exception
        logger.info "Rendering 404: #{exception.message}"
    end

    render :json => {"error" => {"message" => "Invalid input date specified", "code" => 404}}, :status => 404
  end
end
