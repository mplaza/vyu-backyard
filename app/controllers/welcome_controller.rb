class WelcomeController < ApplicationController
	before_action :authenticate_user!
	def index
		Citytimezone.retrieve_times
		@tools = Tool.all.to_a
		@num_unread_email = current_user.query_email
		@threads = Bulletin.all.to_a
	end
end
