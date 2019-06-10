class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  # ログイン済みかどうかを確認するためのメソッド
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  # 未ログインの場合にはログイン画面にリダイレクトさせるメソッド
  def must_be_logged_in
    unless current_user
      flash.notice = "ログインしてください。"
      redirect_to login_url
    end
  end

  # ログイン済みの場合にはトップ画面にリダイレクトさせるメソッド
  def must_not_be_logged_in
    if current_user
      flash.notice = "既にログインしています。"
      redirect_to root_url
    end
  end
end
