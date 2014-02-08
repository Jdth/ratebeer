require 'spec_helper'

describe Beer do
	it "is saved when name and style are set" do
		beer = Beer.create name:"Iso 3", style:"Lager"
		expect(beer).to be_valid
		expect(Beer.count).to eq(1)
	end

	it "is not saved without a name" do
		beer = Beer.create style:"Lager"
		expect(beer).not_to be_valid
		expect(Beer.count).to eq(0)
	end

	it "is not saved without a style" do
		beer = Beer.create name:"Iso 3"
		expect(beer).not_to be_valid
		expect(Beer.count).to eq(0)
	end

end
