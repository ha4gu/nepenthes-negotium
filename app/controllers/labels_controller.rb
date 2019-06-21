class LabelsController < ApplicationController
  before_action :must_be_logged_in

  include Pagy::Backend

  def index
    @pagy, @labels = pagy(@current_user.owned_tags)
  end

  def show
    @tag = @current_user.owned_tags.find_by_id(params[:id])
    if @tag.nil?
      redirect_to labels_url, alert: "指定されたラベルは見つかりません。"
    else
      @pagy, @taggings = pagy(@tag.taggings.includes(:taggable))
    end
  end

  private

  def set_label
    @label = "hoge"
  end
end
