class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :all_followers, :new_followers

	private  
  def current_user  
    @current_user ||= User.find(session[:user_id]) if session[:user_id]  
  end 

  def all_followers
    @followers = User.get_followers(current_user)
  end

  def new_followers
    if old_list = current_user.list
      all_followers - old_list.followers
    else
      all_followers
    end
  end
end
