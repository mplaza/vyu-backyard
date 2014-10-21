require 'tzinfo'

class WelcomeController < ApplicationController
	def index
		@dubai = TZInfo::Timezone.get("Asia/Dubai")
		@dubai_local = @dubai.utc_to_local(Time.now.utc)
		@amman = TZInfo::Timezone.get("Asia/Amman")
		@amman_local = @amman.utc_to_local(Time.now.utc)
		@la = TZInfo::Timezone.get("America/Los_Angeles")
		@la_local = @la.utc_to_local(Time.now.utc)
		@london = TZInfo::Timezone.get("Europe/London")
		@london_local = @la.utc_to_local(Time.now.utc)


		@tools = Tool.all.to_a

	end
end
