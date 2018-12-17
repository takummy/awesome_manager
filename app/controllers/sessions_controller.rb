class SessionsController < ApplicationController
  
  def new
  end

  def create 
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      flash[:success] = "ログインしました"
      redirect_to root_path
    else
      flash[:danger] = "ログインに失敗しました"
      render :new
    end
  end

  def destroy
    log_out
    flash[:info] = "ログアウトしました"
    redirect_to root_path
  end
end
