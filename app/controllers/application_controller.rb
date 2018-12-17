class ApplicationController < ActionController::Base
  include SessionsHelper
  include ErrorHandlers

  def require_login
    unless logged_in?
      flash[:danger] = "ログインしてください"
      redirect_to login_path
    end
  end

  def already_exists
    if logged_in?
      flash[:danger] = "すでに登録済みです"
      redirect_to root_path
    end
  end

  def correct_user
    user = User.find(params[:id])
    unless current_user?(user)
      flash[:danger] = "権限がありません"
      redirect_to root_path
    end
  end
end