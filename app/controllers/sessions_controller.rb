class SessionsController < ApplicationController
  before_action :must_not_be_logged_in, only: [:new, :create]
  before_action :must_be_logged_in, only: [:destroy]

  def new
    # 入力済みメールアドレスを引き継ぐ処理
    @input_email_address ||= ""
  end

  def create
    user = User.find_by(email: session_params[:email])
    if user && user.authenticate(session_params[:password])
      # 認証成功したケース
      session[:user_id] = user.id
      flash.notice = "ログインしました。"
      redirect_to root_path # temp
    else
      # 認証失敗したケース
      flash.now.alert = "メールアドレスかパスワードが正しくありません。"
      # メールアドレスが入力済みの場合には引き継ぐ
      @input_email_address = session_params[:email] if session_params[:email]
      render :new
    end
  end

  def destroy
    # セッション全クリア
    reset_session
    flash.notice = "ログアウトしました。"
    redirect_to root_path # temp
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
