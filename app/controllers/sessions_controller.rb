class SessionsController < ApplicationController  
  def create  
  	auth = request.env["omniauth.auth"]
  	user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
  	session[:user_id] = user.id
  	redirect_to users_interactions_path, :notice => "Signed in!"
  end

	def destroy
    if current_user.list
      current_user.list.delete
    end

    list = List.new(user_id: current_user.id, followers: all_followers)
    
    unless list.save
      flash[:alert] = "Oops! Error saving current followers. Try again later."
    end

		session[:user_id] = nil  
		redirect_to root_url, :notice => "Signed out!"  
	end  
end  