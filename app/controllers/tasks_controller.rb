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
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
