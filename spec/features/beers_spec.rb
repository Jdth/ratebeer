require 'spec_helper'

describe "Beer" do
	let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
	let!(:style) { FactoryGirl.create :style, name:"Lager" }

	before :each do
		FactoryGirl.create :user
		sign_in(username:"Pekka", password:"Foobar1")
	end

	it "is created with valid name" do
		visit new_beer_path
		fill_in('beer_name', with:'Iso 3')
 		expect{
			click_button('Create Beer')
		}.to change{Beer.count}.from(0).to(1)
		expect(page).to have_content "Iso 3"
	end

	it "is not created with invalid (blank) name" do
		visit new_beer_path
		click_button('Create Beer')
		expect(Beer.count).to eq(0)
		expect(page).to have_content "Name can't be blank"
		expect(page).to have_content "New beer"
	end
end
