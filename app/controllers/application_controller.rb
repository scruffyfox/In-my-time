require 'json'

class ApplicationController < ActionController::Base
  before_filter :set_access_control_headers
  protect_from_forgery

  def render_404(exception = nil)
    if exception
        logger.info "Rendering 404: #{exception.message}"
    end

    render :json => {"error" => {"message" => "Invalid input date specified", "code" => 404}}, :status => 404
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'x-timezone,timezone'
    headers['Access-Control-Allow-Credentials'] = "true"
  end
end
