module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def log_out
    session.delete(:user_id)
  end

  def logged_in?
    current_user.present?
  end

  def current_user?(user)
    current_user == user
  end

  def admin_user?
    logged_in? && current_user.admin?
  end
end