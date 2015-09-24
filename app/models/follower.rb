class Follower < ActiveRecord::Base
	belongs_to :blog
	scope :older, -> { where(status: 'old') }
	scope :newer, -> { where(status: 'new') }
end
