class FollowsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)

    respond_to do |format|
      format.html { redirect_back(fallback_location: @user, notice: "Now following #{@user.username}") }
      format.turbo_stream
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)

    respond_to do |format|
      format.html { redirect_back(fallback_location: @user, notice: "Unfollowed #{@user.username}") }
      format.turbo_stream
    end
  end
end
