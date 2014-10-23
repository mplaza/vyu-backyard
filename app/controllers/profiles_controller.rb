class ProfilesController < ApplicationController
	before_action :check_access, :only => [:edit, :update]
	respond_to :json

	def users
		@users = User.all
		respond_with @users
	end

	def index
		@profiles = Profile.all
		respond_with @profiles
	end

	def show
		@profile = Profile.find(params[:id])
	end

	def edit
		@profile = Profile.find(params[:id])
	end

	def update
		@profile = Profile.find(params[:id])
		if @profile.update(profile_params)
			redirect_to welcome_index_path
		else
			render 'edit'
		end
	end

	def check_access
		@profile = Profile.find(params[:id])
		if current_user.id != @profile.user_id 
			flash[:danger] = "You can only edit your own profile"
      		redirect_to profiles_path
		end
	end


	def profile_params
		params.require(:profile).permit(:name, :location, :contact_info, :email, :profile_picture, :job_title)
	end
end
