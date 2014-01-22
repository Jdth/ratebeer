class Beer < ActiveRecord::Base
	belongs_to :brewery
	has_many :ratings

	def average_rating
		total = 0.0
		ratings.each do |rating|
			total = total + rating.score
		end
		total/(ratings.count)	
	end
end
