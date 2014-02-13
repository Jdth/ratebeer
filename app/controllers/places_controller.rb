class PlacesController < ApplicationController
	def index
	end

	def search
		@places = BeermappingApi.places_in(params[:city])
		if @places.empty?
			redirect_to places_path, notice: "No locations in #{params[:city]}"
		else
			render :index
		end
	end

	def show
		@place = BeermappingApi.location(params[:id])
		if @place.name == "No locations Found"
			redirect_to places_path, notice: "Place could not be found"
		end
  end
end
