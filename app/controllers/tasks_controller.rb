class TasksController < ApplicationController
  before_action :must_be_logged_in
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_options_for_select, only: [:new, :edit]

  include Pagy::Backend

  def index
    @q = @current_user.tasks.ransack(params[:q])
    @q.sorts = "created_at desc" if @q.sorts.empty?
    @pagy, @tasks = pagy(@q.result(distinct: false))

    @expire_tasks = ExpireCount.find_by(user_id: @current_user.id)
  end

  def show
    if @task.nil?
      redirect_to tasks_url, alert: "指定されたタスクは見つかりません。"
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = @current_user.id
    if @task && @task.save
      redirect_to tasks_url, notice: "タスクを作成しました。"
    else
      flash.now.alert = "タスクを作成できませんでした。"
      set_options_for_select
      render :new
    end
  end

  def edit
    if @task.nil?
      redirect_to tasks_url, alert: "指定されたタスクは見つかりません。"
    else
      # オーナーありのラベルを編集のためにオーナーなしラベルとしてコピーしておく
      @task.label_list = @task.owner_tags_on(@current_user, :labels)
    end
  end

  def update
    if @task && @task.update(task_params)
      redirect_to tasks_url, notice: "タスクを更新しました。"
    else
      flash.now.alert = "タスクを更新できませんでした。"
      set_options_for_select
      render :edit
    end
  end

  def destroy
    if @task && @task.destroy
      redirect_to tasks_url, notice: "タスクを削除しました。"
    else
      flash.now.alert = "タスクを削除できませんでした。"
      render :show
    end
  end

  private

  def task_params
    date_year   = params[:task]["deadline_date(1i)"]
    date_month  = params[:task]["deadline_date(2i)"]
    date_day    = params[:task]["deadline_date(3i)"]
    time_hour   = params[:task]["deadline_time(4i)"]
    time_minute = params[:task]["deadline_time(5i)"]

    if date_year.present? && date_month.present? && date_day.present? && time_hour.present? && time_minute.present?
      # すべての項目が入力済みの場合: _dateも_timeも有効
      params.require(:task).permit(:subject, :detail, :status, :priority, :label_list, :deadline_date, :deadline_time)
    elsif date_year.present? && date_month.present? && date_day.present?
      # 日付部分は入力済みだが時刻部分は不十分: _dateのみ有効
      params.require(:task).permit(:subject, :detail, :status, :priority, :label_list, :deadline_date)
    elsif time_hour.present? && time_minute.present?
      # 時刻部分は入力済みだが日付部分は不十分: _timeのみ有効
      params.require(:task).permit(:subject, :detail, :status, :priority, :label_list, :deadline_time)
    else
      # 日付部分も時刻部分も不十分: _dateも_timeも無効にしておく
      params.require(:task).permit(:subject, :detail, :status, :priority, :label_list)
    end
  end

  def set_task
    @task = @current_user.tasks.find_by(id: params[:id])
  end

  def set_options_for_select
    # 状態
    @status_options = []
    Task.statuses.keys.each do |state|
      @status_options << [Task.human_attribute_name("status.#{state}"), state]
    end
    # 優先度
    @priority_options = []
    Task.priorities.keys.each do |priority|
      @priority_options << [Task.human_attribute_name("priority.#{priority}"), priority]
    end
  end
end
