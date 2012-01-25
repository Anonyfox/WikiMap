#encoding: utf-8

require_relative "data_controller"

class ShoesController
	attr_accessor :data_controller, :searched, :current_search
	attr_accessor :is_working, :is_back_search

	def initialize
		@data_controller = DataController.new
		@current_search = {phrase: "", thumbnail: nil} 	# current searchstring
		@searched = []
		@is_working = false
		@is_back_search = false
	end

	def save_last_request
		# Check if Back-Button is pressed
		unless @is_back_search
			# Push the last search and thumbnail to stack
			@searched << @current_search if  @current_search != {phrase: "", thumbnail: nil}
			@current_search = {phrase: "", thumbnail: nil}
		end
		@is_back_search = false
	end

	def get_last_request
		search = {phrase: "", thumbnail: nil}
		search = searched.pop if @searched != []
		search
	end

	# render the full-screen MindMap to a given filename.
	def export_mindmap
		return false if @current_search == {phrase: "", thumbnail: nil}
		return false unless @current_search[:thumbnail]

		target_file = ask_save_file
		return false unless target_file && target_file != ""
		@data_controller.render_picture(
			@current_search[:phrase],
			@data_controller.look_for(@current_search[:phrase]),
			target_file,
		)
	end

end