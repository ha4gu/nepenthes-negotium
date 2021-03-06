class ApplicationController < ActionController::Base
  helper_method :current_user

  class NotAdminError < StandardError
  end

  rescue_from NotAdminError, with: :show_not_admin_error_page

  private

  # ログイン済みかどうかを確認するためのメソッド
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
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

  # 管理者でない場合には例外を発生させるメソッド
  def must_be_admin
    unless @current_user.admin?
      raise NotAdminError
    end
  end

  # 管理者でない場合の例外用エラーページ表示
  def show_not_admin_error_page(error)
    @error = error
    render "layouts/not_admin_error"
  end
end
