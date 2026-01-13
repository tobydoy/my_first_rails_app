class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :following, :followers]
  before_action :require_current_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to feed_path, notice: "Welcome to Social Recommendations! Your account has been created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @recommendations = @user.recommendations.recent.limit(20)
  end

  def edit
    # Edit profile form
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Profile updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def following
    @users = @user.following
  end

  def followers
    @users = @user.followers
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def require_current_user
    redirect_to root_path, alert: "You can only edit your own profile" unless @user == current_user
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :bio, :avatar_url)
  end
end
