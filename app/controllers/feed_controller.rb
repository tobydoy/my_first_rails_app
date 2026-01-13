class FeedController < ApplicationController
  skip_before_action :require_login, only: [:index]

  def index
    # Redirect non-logged-in users to login page
    unless logged_in?
      redirect_to login_path, alert: "Please log in to view your feed"
      return
    end

    # Get recommendations from users that current user follows
    following_ids = current_user.following.pluck(:id)

    if following_ids.any?
      @recommendations = Recommendation.where(user_id: [current_user.id] + following_ids)
                                      .includes(:user, :likes, :comments)
                                      .recent
                                      .limit(50)
    else
      # If not following anyone, show popular recommendations
      @recommendations = Recommendation.includes(:user, :likes, :comments)
                                      .popular
                                      .limit(20)
    end

    @categories = Recommendation.distinct.pluck(:category).compact.sort
  end
end
