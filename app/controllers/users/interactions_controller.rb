class Users::InteractionsController < ApplicationController
	def index
	end

	def new_post
		if post_params[:image]
			# 
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
		params.permit(:title, :body, :image)
	end
end
