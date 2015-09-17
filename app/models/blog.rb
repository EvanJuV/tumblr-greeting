class Blog < ActiveRecord::Base
	belongs_to :user
	has_many :followers
end
