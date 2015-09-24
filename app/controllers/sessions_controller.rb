class SessionsController < ApplicationController  
  def create  
  	auth = request.env["omniauth.auth"]
  	user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)

    response_blogs = auth.extra.raw_info.blogs.map { |b| b.name } 
    user.update_blogs(response_blogs)
    user.update_followers

  	session[:user_id] = user.id
  	redirect_to users_interactions_path, :notice => "Signed in!"
  end

	def destroy
		session[:user_id] = nil  
    session[:blog_id] = nil
		redirect_to root_url, :notice => "Signed out!"  
	end  
end  