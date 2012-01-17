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
		$wikimap = OpenStruct.new

		# prepare the data and internetz stuff
		$wikimap.controller = DataController.new
		$wikimap.searched_last = {} 	# Aktueller Suchstring
		$wikimap.searched = []
		$wikimap.is_working = false
		$wikimap.image_counter = 0
		$wikimap.ressource_thumbnail_path = Array.new
		$wikimap.ressource_thumbnail_path << ENV['HOME']+"/.wikimap/tmp/my_graph_" << $IMAGE_COUNTER << ".png"
		$wikimap.current_mind_map 		# Aktueller Image-Path der Mindmap
		$wikimap.is_back_search = false

		# initialize the ui-elements
		stack do
			background darkslateblue .. cornflowerblue
			$wikimap.title_bar = title_bar
			$wikimap.status_bar = status_bar "Welcome to Wikimap!"
		end
		flow width: 1000 do
			stack(width:300) { 
				background antiquewhite .. white, angle: 90
				$wikimap.options_list = options_list ["testitem", "another one"] 
			}
			stack(width:660) { $wikimap.mind_map = mind_map }
		end
	end

	# define some hotkeys
	keypress do |k|
		$wikimap.title_bar.process_search if k == "\n"
		$wikimap.title_bar.export_mindmap if k == :control_s
	end # hotkeys
end