class TasksController < ApplicationController
  def index
    @page_title = "タスク一覧"
    @tasks = Task.all
  end

  def show
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
