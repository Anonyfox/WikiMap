#encoding: utf-8

Shoes.setup do 
	gem 'kioku'
	gem 'net-ping'
end

require './app/controllers/data_controller'

Shoes.app title:"WikiMap", height:750, width: 1000, resizable: false do
	# Imports
	# require the widget-files
	Dir.glob(File.dirname(__FILE__) + '/app/views/*', &method(:require) )
	require "uri"
	require "ostruct"
	
	stack do
		# Create global OpenStruct
		$app = OpenStruct.new
		$widgets = OpenStruct.new

		# prepare the data and internetz stuff
		$app.controller = DataController.new
		$app.searched_last = {} 	# Aktueller Suchstring
		$app.searched = []
		$app.is_working = false
		$app.image_counter = 0
		$app.ressource_thumbnail_path = Array.new
		$app.ressource_thumbnail_path << ENV['HOME']+"/.wikimap/tmp/my_graph_" << $app.image_counter << ".png"
		$app.current_mind_map 		# Aktueller Image-Path der Mindmap
		$app.is_back_search = false

		# initialize the ui-elements
		stack do
			background darkslateblue .. cornflowerblue
			$widgets.title_bar = title_bar
			$widgets.status_bar = status_bar "Welcome to Wikimap!"
		end
		flow width: 1000 do
			stack(width:300) { 
				background antiquewhite .. white, angle: 90
				$widgets.options_list = options_list ["testitem", "another one"] 
			}
			stack(width:660) { $widgets.mind_map = mind_map }
		end
	end

	# define some hotkeys
	keypress do |k|
		$widgets.title_bar.process_search if k == "\n"
		$widgets.title_bar.export_mindmap if k == :control_s
	end # hotkeys
end