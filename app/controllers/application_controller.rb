class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :all_followers, :new_followers, :signed_in

	private
  def current_user  
    @current_user ||= User.find(session[:user_id]) if session[:user_id] 
  end 

  def signed_in_user
    unless current_user
      redirect_to root_path, alert: "You must sign in before you do that"  
    end
  end
end
