class Admin::UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: %i(show edit update destroy)

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "#{@user.name}を登録しました！"
      redirect_to admin_user_path(@user)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "#{@user.name}を編集しました！"
      redirect_to admin_user_path(@user)
    else
      render :edit
    end
  end

  def show
  end

  def index
    @users = User.all.includes(:tasks)
                 .page(params[:page]).per(20)
  end

  def destroy
    if @user.destroy
      flash[:info] = "#{@user.name}を削除しました！"
      redirect_to admin_users_path
    else
      flash[:danger] = "管理ユーザーは1人以上必要です"
      redirect_to admin_user_path(@user)
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
  end
end
