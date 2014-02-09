require 'spec_helper'

describe "Beer" do
	let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }

	before :each do
		visit new_beer_path
		select('Lager', from:'beer[style]')
		select('Koff', from:'beer[brewery_id]')
	end

	it "can be created with valid name" do
		fill_in('beer_name', with:'Iso 3')

 		expect{
			click_button "Create Beer"
		}.to change{Beer.count}.from(0).to(1)
		expect(page).to have_content "Iso 3"
	end

	it "cannot be created with invalid (blank) name" do
		fill_in('beer_name', with:'')
		
		click_button "Create Beer"
		expect(Beer.count).to eq(0)
		expect(page).to have_content "Name can't be blank"
	end

end
