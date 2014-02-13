require 'spec_helper'

describe "Places" do
	it "if none returned by the API, message is shown" do
		BeermappingApi.stub(:places_in).with("location without places").and_return([])

		visit places_path
		fill_in('city', with: 'location without places')
    click_button "Search"

		expect(page).to have_content "No locations in location without places"
	end

	it "if one is returned by the API, it is shown at the page" do
		BeermappingApi.stub(:places_in).with("kumpula").and_return([ Place.new(:name => "Oljenkorsi")])
		
		visit places_path
		fill_in('city', with: 'kumpula')
		click_button "Search"

		expect(page).to have_content "Oljenkorsi"
	end

	it "if many returned by the API, all shown at the page" do
		BeermappingApi.stub(:places_in).with("helsinki").and_return([ Place.new(:name => "Oljenkorsi"), Place.new(:name => "Kaisla") ])
    
    visit places_path
    fill_in('city', with: 'helsinki')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
		expect(page).to have_content "Kaisla"
	end

end
