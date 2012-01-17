#encoding: utf-8

Shoes.setup do
	#gem 'graph'
	gem 'kioku'
end

require 'fileutils'
require 'kioku'
require './app/lib/wiki_client'
#require './app/controllers/page_controller'
#require './app/db/data_base'
require './app/db/kioku_client'

Shoes.app title: "WikiMap", width: 1000, height: 750 do
	require './app/widgets/item_url'
	require './app/widgets/mind_map'

	# Initialize
	require "./app/lib/init"
	Init.on_startup(self)

	flow do

		# title flow
		flow do
			@back = button "<<"
			@back.click {
				unless $last_choices.empty?
					$search.text = $last_choices.pop
					redraw_options
				end
			}
			$search = edit_line width: 300
			# do search button
			@go = button "search!"
			@go.click{ $redraw_options.call }
			# random search button
			@random = button "random!"
			@random.click { alert "not yet implemented!" }
			# export button
			@export = button "export img"
			@export.click {
				if $picture_created
					destination = ask_save_file
					if destination && destination != ""
						WikiClient.output $clicked, $answer, $img_counter, destination if destination
						alert "export successful to #{destination}"
					end
				else
					alert "no mindmap available!"
				end
			}
			# options menu button
			@options = button "options"
			@options.click { alert "todo ;) " }
			# help menu button
			@help = button "help"
			@help.click { "todo ;) " }
		end #title flow
		
		# progress bar
		flow do
			$progress = progress width: 600
			$progress.fraction = 0.0
			$progress_info = para "ready", size: 9
		end

		# list stack
		$list_stack = stack width: 300, height: 600, scroll: true

		# mindmap picture
		stack width: 700 do
			$mindmap = mind_map
		end

	end

	keypress do |k|

	end
	
end