class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :all_followers, :new_followers, :authenticate_user

	private
  def current_user  
    @current_user ||= User.find(session[:user_id]) if session[:user_id] 
  end 

  def authenticate_user
    if @current_user
      true
    else
      false
    end
  end

  def new_followers(blog)
    blog.list.followers - blog.list.last_followers
  end
end
