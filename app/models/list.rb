class List < ActiveRecord::Base
	belongs_to :blog
	serialize :followers, Array
	serialize :last_followers, Array
	serialize :new_followers , Array
end
