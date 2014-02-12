class Brewery < ActiveRecord::Base
	include RatingAverage
	
	validates :name, presence: true 
	validates :year, numericality: {only_integer: true,
																	greater_than_or_equal_to: 1042,
																	less_than_or_equal_to: ->(_) { Time.now.year}
	 																}

	has_many :beers, :dependent => :destroy
	has_many :ratings, :through => :beers	
end
