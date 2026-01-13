class CommentsController < ApplicationController
  before_action :set_recommendation

  def create
    @comment = @recommendation.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @recommendation, notice: "Comment added successfully!"
    else
      redirect_to @recommendation, alert: "Failed to add comment: #{@comment.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @comment = @recommendation.comments.find(params[:id])

    if @comment.user == current_user
      @comment.destroy
      redirect_to @recommendation, notice: "Comment deleted successfully!"
    else
      redirect_to @recommendation, alert: "You can only delete your own comments"
    end
  end

  private

  def set_recommendation
    @recommendation = Recommendation.find(params[:recommendation_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
