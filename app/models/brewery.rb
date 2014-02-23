class Brewery < ActiveRecord::Base
	include RatingAverage
	
	validates :name, presence: true 
	validates :year, numericality: {only_integer: true,
																	greater_than_or_equal_to: 1042,
																	less_than_or_equal_to: ->(_) { Time.now.year}
	 																}

	has_many :beers, :dependent => :destroy
	has_many :ratings, :through => :beers	

	scope :active, -> { where active:true }
	scope :retired, -> { where active:[nil,false]}

	def self.top(n)
		sorted_by_rating_in_desc_order = Brewery.all.sort_by{ |b| -(b.average_rating||0) } 
		sorted_by_rating_in_desc_order.first(n)
	end

	def to_s
		"#{name}"	
	end
end
