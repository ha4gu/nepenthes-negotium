class TasksController < ApplicationController
  def index
    @page_title = "タスク一覧"
    @tasks = Task.all
  end

  def show
    @page_title = "タスク詳細"
    @task = Task.find_by_id(params[:id])
    if @task.nil?
      redirect_to tasks_url, alert: "指定されたタスクは見つかりません。"
    end
  end

  def new
    @page_title = "タスク作成"
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task && @task.save
      redirect_to tasks_url, notice: "タスクを作成しました。"
    else
      flash.now.alert = "タスクを作成できませんでした。"
      @page_title = "タスク作成"
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def task_params
    params.require(:task).permit(:subject, :detail)
  end
end
