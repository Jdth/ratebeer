require 'spec_helper'
include OwnTestHelper

describe "User's page" do
	let(:user){ FactoryGirl.create(:user) }	
	let(:other_user){ FactoryGirl.create(:user, username:"Jukka") }
	
	it "shows ratings given by user" do
		beer = create_beer_with_rating(23, user)

		visit user_path(user)
		expect(page).to have_content('Pekka')
		expect(page).to have_content("#{beer.name} 23")
	end

	it "doesn't show ratings given by other users" do
		beer = create_beer_with_rating(10, other_user)

    visit user_path(user)
    expect(page).to have_content('Pekka')
    expect(page).not_to have_content("#{beer.name} 10")
	end

end

def create_beer_with_rating(score, user)
	beer = FactoryGirl.create(:beer)
	FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end
