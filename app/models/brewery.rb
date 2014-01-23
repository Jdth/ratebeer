class Brewery < ActiveRecord::Base
	has_many :beers, :dependent => :destroy
	has_many :ratings, :through => :beers

	def average_rating
		ratings.inject(0) {|total, rating| total + rating.score}.to_f / ratings.count
	end
end
