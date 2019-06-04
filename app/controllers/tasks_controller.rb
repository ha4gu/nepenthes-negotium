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
    params.require(:task).permit(:subject, :detail)
  end

  def set_task
    @task = Task.find_by_id(params[:id])
  end
end
