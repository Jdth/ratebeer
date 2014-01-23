class Beer < ActiveRecord::Base
	belongs_to :brewery
	has_many :ratings

	def average_rating
		ratings.inject(0) { |total, rating| total + (rating.score) }.to_f / ratings.count
	end
end
