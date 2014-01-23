class Beer < ActiveRecord::Base
	belongs_to :brewery
	has_many :ratings, :dependent => :destroy

	def average_rating
		ratings.inject(0) { |total, rating| total + (rating.score) }.to_f / ratings.count
	end

	def to_s
		"#{name}, #{brewery.name}"
	end
end
