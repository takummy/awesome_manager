module ErrorHandlers
  extend ActiveSupport::Concern

  included do
    rescue_from ApplicationController::Forbidden, with: :rescue403
  end

  class Forbidden < ActionController::ActionControllerError; end

  def rescue403
    render file: "public/403.html", layout: false, status: 403
  end

  def require_admin
    unless logged_in? && current_user.admin?
      raise Forbidden
    end
  end
end