class LabelsController < ApplicationController
  before_action :must_be_logged_in

  def index
    @labels = @current_user.owned_tags
  end

  def show
  end

  private

  def set_label
    @label = "hoge"
  end
end
