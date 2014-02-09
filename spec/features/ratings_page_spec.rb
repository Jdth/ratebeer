require 'spec_helper'

describe "Ratings page" do
	let(:user){ FactoryGirl.create(:user) }
	let(:beer){ FactoryGirl.create(:beer) }

	before :each do
		@ratings = [12, 23, 17]
		@ratings.each do |rating_score|
			FactoryGirl.create(:rating, score:rating_score, beer:beer, user:user)
		end
	 	visit ratings_path	
	end

	it "shows the number of ratings" do
		expect(page).to have_content "Number of ratings: #{@ratings.count}"
	end

	it "shows the list of ratings" do
		@ratings.each do |score|
			expect(page).to have_content score
		end	
	end

end
