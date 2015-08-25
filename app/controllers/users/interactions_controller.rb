class Users::InteractionsController < ApplicationController
	before_action :authenticate_user

	def index
	end

	def new_post
		blog = Blog.find(post_params[:blog_post_id])
		if post_params[:image]
			uploader = ImageUploader.new 
			uploader.cache!(post_params[:image])
			file_path = uploader.file.path
			if User.new_image_post(file_path, post_params[:body], current_user, blog)
				flash[:notice] = "Post created"
			else
				flash[:alert] = "The post couldn't be created"
			end
		else
			if User.new_text_post(post_params[:title], post_params[:body], current_user, blog)
				flash[:notice] = "Post created"
			else
				flash[:alert] = "The post couldn't be created"
			end
		end
		redirect_to users_interactions_path
	end

	def change_blog
		session[:blog_id] = params[:blog_id]
		logger.info "Chtml #{session[:blog_id]}"
		respond_to do |format|
		  format.js { render nothing: true }
		  format.html
		end
	end

	private
	def post_params
		params.require(:post).permit :utf8, :multipart, :title, :body, :image, :blog_post_id
	end
end
