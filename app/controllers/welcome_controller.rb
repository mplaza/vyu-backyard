


class WelcomeController < ApplicationController
	client = Google::APIClient.new
	def index
		Citytimezone.retrieve_times
		
		@tools = Tool.all.to_a
	end
end
