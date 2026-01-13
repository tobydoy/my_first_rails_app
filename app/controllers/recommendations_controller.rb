class RecommendationsController < ApplicationController
  before_action :set_recommendation, only: [:show, :edit, :update, :destroy]
  before_action :require_owner, only: [:edit, :update, :destroy]

  def index
    @recommendations = Recommendation.includes(:user).recent

    # Filter by category if provided
    @recommendations = @recommendations.by_category(params[:category]) if params[:category].present?

    # Filter by type if provided
    @recommendations = @recommendations.send(params[:type]) if params[:type].in?(['evergreen', 'time_location'])

    # Search functionality (basic)
    if params[:search].present?
      @recommendations = @recommendations.where("title LIKE ? OR description LIKE ?",
                                                "%#{params[:search]}%",
                                                "%#{params[:search]}%")
    end

    @recommendations = @recommendations.page(params[:page]).per(20) if defined?(Kaminari)
  end

  def show
    @comments = @recommendation.comments.includes(:user).recent
    @comment = Comment.new
  end

  def new
    @recommendation = current_user.recommendations.build
  end

  def create
    @recommendation = current_user.recommendations.build(recommendation_params)

    if @recommendation.save
      redirect_to @recommendation, notice: "Recommendation created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Edit form
  end

  def update
    if @recommendation.update(recommendation_params)
      redirect_to @recommendation, notice: "Recommendation updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recommendation.destroy
    redirect_to recommendations_path, notice: "Recommendation deleted successfully!"
  end

  private

  def set_recommendation
    @recommendation = Recommendation.find(params[:id])
  end

  def require_owner
    unless @recommendation.user == current_user
      redirect_to @recommendation, alert: "You can only edit your own recommendations"
    end
  end

  def recommendation_params
    params.require(:recommendation).permit(
      :title, :description, :recommendation_type, :category,
      :product_url, :affiliate_link, :image_url,
      :location_name, :latitude, :longitude,
      :event_date, :is_event
    )
  end
end
