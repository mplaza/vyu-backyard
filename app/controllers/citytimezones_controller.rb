class CitytimezonesController < ApplicationController
	respond_to :json

	def index
		@citytimezones = Citytimezone.all
		respond_with @citytimezones
	end

	def show
		@citytimezone = Citytimezone.find(params[:id])
		respond_with @citytimezone
	end
end
