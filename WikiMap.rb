#encoding: utf-8

Shoes.setup do
	#gem 'graph'
end

require 'fileutils'
require './app/lib/wiki_client'

Shoes.app title: "WikiMap", width: 1000, height: 700 do

	require './app/widgets/item_url'
	require './app/widgets/mind_map'

	# some simple global vars
	$picture_created = false
	$choices = nil
	$clicked = nil
	$answer = nil
	$last_choices = []
	$img_counter = 0
	$ERROR_TOO_MANY = Proc.new { 
		alert "sorry, too many items! (#{$answer.size})" 
	}

	# standard routines
	$redraw_options = Proc.new {|list=nil|
		$list_stack.clear {
			if list
				$choices = list
		  else
				$choices = WikiClient.ask @search.text
			end
			$choices.each {|name| item_url name }
		}
	}
	$update_state = Proc.new {|name|
		$clicked = name
		$last_choices << $clicked.dup
		$answer = WikiClient.get name
		$redraw_options.call $anwer
		WikiClient.output name, $answer, $img_counter
		$mindmap.update
		$picture_created ||= true
		$img_counter += 1
	}

	flow do

		# title flow
		flow do
			@back = button "<<"
			@back.click {
				unless $last_choices.empty?
					@search.text = $last_choices.pop
					redraw_options
				end
			}
			@search = edit_line width: 300
			# do search button
			@go = button "search!"
			@go.click{ 
				#$list_stack.clear {
				#	$choices = WikiClient.ask @search.text
				#	$choices.each {|name| item_url name }
				#}
				$redraw_options.call
			}
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
		
		# list stack
		$list_stack = stack width: 300

		# mindmap picture
		stack width: 700 do
			$mindmap = mind_map
		end

	end

	keypress do |k|

	end
	
end