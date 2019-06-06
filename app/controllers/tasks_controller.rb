class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
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
      params.require(:task).permit(:subject, :detail, :deadline_date, :deadline_time)
    elsif date_year.present? && date_month.present? && date_day.present?
      # 日付部分は入力済みだが時刻部分は不十分: _dateのみ有効
      params.require(:task).permit(:subject, :detail, :deadline_date)
    elsif time_hour.present? && time_minute.present?
      # 時刻部分は入力済みだが日付部分は不十分: _timeのみ有効
      params.require(:task).permit(:subject, :detail, :deadline_time)
    else
      # 日付部分も時刻部分も不十分
      params.require(:task).permit(:subject, :detail)
    end
  end

  def set_task
    @task = Task.find_by_id(params[:id])
  end
end
