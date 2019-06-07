class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_options_for_select, only: [:new, :edit]

  def index
    params.permit(:sort)
    @q = Task.ransack(params[:q])
    @tasks = @q.result(distinct: true)
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
      params.require(:task).permit(:subject, :detail, :status, :deadline_date, :deadline_time)
    elsif date_year.present? && date_month.present? && date_day.present?
      # 日付部分は入力済みだが時刻部分は不十分: _dateのみ有効
      params.require(:task).permit(:subject, :detail, :status, :deadline_date)
    elsif time_hour.present? && time_minute.present?
      # 時刻部分は入力済みだが日付部分は不十分: _timeのみ有効
      params.require(:task).permit(:subject, :detail, :status, :deadline_time)
    else
      # 日付部分も時刻部分も不十分: _dateも_timeも無効にしておく
      params.require(:task).permit(:subject, :detail, :status)
    end
  end

  def set_task
    @task = Task.find_by_id(params[:id])
  end

  def set_options_for_select
    @options_for_select = []
    Task.statuses.keys.each do |state|
      @options_for_select << [Task.human_attribute_name("status.#{state}"), state]
    end
  end
end
