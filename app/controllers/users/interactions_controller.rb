class Users::InteractionsController < ApplicationController
	def index
		@followers = User.get_followers(current_user)
	end
end
