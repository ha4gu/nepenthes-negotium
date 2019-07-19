class LabelsController < ApplicationController
  before_action :must_be_logged_in

  include Pagy::Backend

  def index
    @pagy, @labels = pagy(@current_user.owned_tags)
  end

  def show
    @label = @current_user.owned_tags.find_by(id: params[:id])
    if @label.nil?
      redirect_to labels_url, alert: "指定されたラベルは見つかりません。"
    else
      @pagy, @tasks = pagy(@label.taggings.includes(:taggable))
    end
  end
end
