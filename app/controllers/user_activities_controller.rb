class UserActivitiesController < ApplicationController
  load_and_authorize_resource

  before_action :require_login

  def index
    @user_activities = current_user.user_activities
    @user_calories = UserActivity.user_calories_for_today(current_user,"to-date")
    @user_minutes = UserActivity.user_minutes_for_today(current_user,"to-date")
  end

  def new
    @user_activity = UserActivity.new
    @user_activities = UserActivity.user_activities_for_today(current_user)
    @user_calories = UserActivity.user_calories_for_today(current_user)
    @user_minutes = UserActivity.user_minutes_for_today(current_user)
  end
  
  def create
    @user_activity = UserActivity.new(user_activity_params)
    @user_activity.user_id = current_user.id
    @user_activities = UserActivity.user_activities_for_today(current_user)

    if @user_activity.save
      flash[:success] = "Activity Logged!"
      logger.debug "Created User Activity with hash #{@user_activity.attributes.inspect}"
      redirect_to :back
    else    
      flash[:error] = "Activity could not be logged!"
      logger.error "Unable to create User Activity with hash #{@user_activity.attributes.inspect}"
      render :new
    end

  end
  

  def destroy
    
    user_activity = UserActivity.find(params[:id])
    
    logger.debug "User to destroy #{params[:id]}"
    
    if user_activity.destroy
      flash[:success] = "Activity was removed!" 
      redirect_to :back
    else    
      flash[:error] = "Activity could not be removed!"
      logger.error "Unable to destroy UserActivity with id #{params[:id]}"
      redirect_to :back
    end

  end

  private
  def user_activity_params
      params.require(:user_activity).permit(
        :activity_id,
        :duration_minutes,
        :calories,
        :intensity
      )
    end
end
