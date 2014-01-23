module RatingAverage
  extend ActiveSupport::Concern

	def average_rating
		ratings.inject(0) { |total, rating| total + (rating.score) }.to_f / ratings.count
	end 
end

