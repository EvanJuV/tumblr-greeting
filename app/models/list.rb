class List < ActiveRecord::Base
	belongs_to :user
	serialize :followers, Array
end
