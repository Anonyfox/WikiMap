#encoding: utf-8

Shoes.setup do 
	gem 'kioku'
	gem 'net-ping'
end

Shoes.app title:"WikiMap", height:700, width: 1000, resizable: false do
	# require the widget-files, libraries and gems
	Dir.glob(File.dirname(__FILE__) + '/app/views/*', &method(:require) )
	Dir.glob(File.dirname(__FILE__) + '/app/controllers/*', &method(:require) )
	require "uri"
	require "ostruct"
	
	stack do
		# Create global OpenStructs
		$app = OpenStruct.new
		$widgets = OpenStruct.new
		
		# Initialize new Shoes Controller
		$app = ShoesController.new

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