class UsersController < ApplicationController
  before_action :must_not_be_logged_in, only: [:new, :create]
  before_action :must_be_logged_in, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    if @user.nil?
      redirect_to users_url, alert: "指定されたユーザーは見つかりません。"
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user && @user.save
      redirect_to users_url, notice: "ユーザー #{@user.name} を作成しました。"
    else
      flash.now.alert = "ユーザーを作成できませんでした。"
      render :new
    end
  end

  def edit
    if @user.nil?
      redirect_to users_url, alert: "指定されたユーザーは見つかりません。"
    end
  end

  def update
    if @user && @user.update(user_params)
      redirect_to users_url, notice: "ユーザー #{@user.name} を更新しました。"
    else
      flash.now.alert = "ユーザー #{@user.name} を更新できませんでした。"
      render :edit
    end
  end

  def destroy
    if @user && @user.destroy
      redirect_to users_url, notice: "ユーザーを削除しました。"
    else
      flash.now.alert = "ユーザーを削除できませんでした。"
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find_by_id(params[:id])
  end
end
