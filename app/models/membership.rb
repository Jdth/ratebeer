class Membership < ActiveRecord::Base
	belongs_to :beer_club
	belongs_to :user
	
	validate :user_can_be_member_only_once_in_beer_club
	
	def user_can_be_member_only_once_in_beer_club
		if beer_club.users.include?(User.find_by id: user_id)
			errors.add(:beer_club, "includes the user already")
		end
	end
end
