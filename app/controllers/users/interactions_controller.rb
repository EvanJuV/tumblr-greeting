class Users::InteractionsController < ApplicationController
	before_action :authenticate_user

	def index
	end

	def new_post
		if post_params[:image]
			uploader = ImageUploader.new 
			uploader.cache!(post_params[:image])
			file_path = uploader.file.path
			if User.new_image_post(file_path, post_params[:body], current_user)
				flash[:notice] = "Post created"
			else
				flash[:alert] = "The post couldn't be created"
			end
		else
			if User.new_text_post(post_params[:title], post_params[:body], current_user)
				flash[:notice] = "Post created"
			else
				flash[:alert] = "The post couldn't be created"
			end
		end
		redirect_to users_interactions_path
	end

	private
	def post_params
		params.require(:post).permit :utf8, :multipart, :title, :body, :image
	end
end
