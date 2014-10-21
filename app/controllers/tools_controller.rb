class ToolsController < ApplicationController

	def show
		@tool = Tool.find(params[:id])
	end

	def new
		@tool = Tool.new
	end

	def create
		@tool = Tool.new(tool_params)
		if @tool.save
			redirect_to tool_path(@tool)
		else
			render 'new'
		end
	end

	def edit
		@tool = Tool.find(params[:id])
	end

	def update
		@tool = Tool.find(params[:id])
		if @tool.update
			redirect_to tool_path(@tool)
		else
			render 'edit'
		end
	end

	def tool_params
		params.require(:tool).permit(:name, :link, :description)
	end
end
