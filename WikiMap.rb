#encoding: utf-8

Shoes.setup do 
	gem 'kioku'
	gem 'net-ping'
end

require './app/controllers/data_controller'

Shoes.app title:"WikiMap", height:750, width: 1000 do
	stack do
		# require the widget-files
		Dir.glob(File.dirname(__FILE__) + '/app/views/*', &method(:require) )

		# prepare the data and internetz stuff
		$CONTROLLER = DataController.new
		$CURRENT_SEARCH = nil 	# Aktueller Suchstring
		$SEARCHED = []
		$IS_WORKING = false
		$IMAGE_COUNTER = 0
		$RESSOURCE_THUMBNAIL_PATH = Array.new
		$RESSOURCE_THUMBNAIL_PATH << "./tmp/my_graph_" << $IMAGE_COUNTER << ".png"
		$CURRENT_MIND_MAP 		# Aktueller Image-Path der Mindmap

		# initialize the ui-elements
		stack do
			background darkslateblue .. cornflowerblue
			$TITLE_BAR = title_bar
			$STATUS_BAR = status_bar "Welcome to Wikimap!"
		end
		flow width: 1000 do
			stack(width:300) { 
				background antiquewhite .. white, angle: 90
				$OPTIONS_LIST = options_list ["testitem", "another one"] 
			}
			stack(width:660) { $MIND_MAP = mind_map }
		end
	end

	# define some hotkeys
	keypress do |k|
		$TITLE_BAR.lookup_text if k == "\n"
	end # hotkeys

end