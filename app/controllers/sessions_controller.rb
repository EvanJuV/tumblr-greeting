class SessionsController < ApplicationController  
  def create  
  	auth = request.env["omniauth.auth"]
  	user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)

    response_blogs = auth.extra.raw_info.blogs.map { |b| b.name } 
    user_blogs = user.blogs.map { |b| b.name }
    diff = response_blogs - user_blogs

    diff.each do |d|
      new_blog = Blog.new(name: d)
      user.blogs << new_blog
    end

    User.update_followers(user)

  	session[:user_id] = user.id
  	redirect_to users_interactions_path, :notice => "Signed in!"
  end

	def destroy
		session[:user_id] = nil  
    session[:blog_id] = nil
		redirect_to root_url, :notice => "Signed out!"  
	end  
end  