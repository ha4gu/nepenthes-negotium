class LabelsController < ApplicationController
  before_action :must_be_logged_in

  def index
    # show only labels which are tagged on user's tasks
    tasks = @current_user.tasks
    whole_labels = Task.tags_on(:labels)
    @labels = []
    whole_labels.each do |label|
      if tasks.tagged_with(label.name).count >= 1
        @labels << label
      end
    end

  end

  def show
  end

  private

  def set_label
    @label = "hoge"
  end
end
