class Brewery < ActiveRecord::Base
	include RatingAverage
	
	validates :name, presence: true 
	validates :year, numericality: {only_integer: true,
																	greater_than_or_equal_to: 1042 }
	validate :year, :must_be_less_than_or_equal_to_current_year

	has_many :beers, :dependent => :destroy
	has_many :ratings, :through => :beers
	
	def must_be_less_than_or_equal_to_current_year
		if year > Time.now.year
			errors.add(:year, "cannot be greater than current year")
		end
	end
end
