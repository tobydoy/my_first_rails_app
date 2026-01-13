class LikesController < ApplicationController
  def create
    @recommendation = Recommendation.find(params[:recommendation_id])
    @recommendation.toggle_like(current_user)

    respond_to do |format|
      format.html { redirect_back(fallback_location: @recommendation) }
      format.turbo_stream
    end
  end
end
