class RatingsController < ApplicationController
	def index
		@top_beers = Beer.top 3
		@top_breweries = Brewery.top 3
		@top_styles = Style.top 3
		@most_active_users = User.most_active 3
		@recent_ratings = Rating.recent
	end

	def new
		@rating = Rating.new
		@beers = Beer.all
	end

	def create
		@rating = Rating.new params.require(:rating).permit(:score, :beer_id)
		if current_user.nil?
			redirect_to signin_path, notice: 'You should sign in to rate beers'		
		elsif @rating.save
			current_user.ratings << @rating
			redirect_to user_path current_user
		else
			@beers = Beer.all
			render :new
		end
	end

	def destroy
		rating = Rating.find(params[:id])
		rating.delete if current_user == rating.user
		redirect_to :back
	end

end
