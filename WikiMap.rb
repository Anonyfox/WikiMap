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
		$DATA = DataController.new
		$SEARCHED_CURRENT = nil
		$SEARCHED = []
		$IS_WORKING = false

		# initialize the ui-elements
		stack do
			background darkslateblue .. cornflowerblue
			$TITLE_BAR = title_bar
			$STATUS_BAR = status_bar
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