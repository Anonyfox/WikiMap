#encoding: utf-8

require_relative 'item_url'

# This Widget simply contains a list of items. It also gives
# the items their complex behaviour when clicked.
class Shoes::OptionsList < Shoes::Widget
	attr_reader :list

	# you may give this widget an array of strings to
	# show when rendered first. 
	def initialize start_list=[]
		@list = start_list
		@main = stack width: 300, height: 630, scroll: true
		draw_normal start_list
	end

	# the core drawing method. expects an array of strings
	# to draw all the items.
	def draw_normal list=[]
		@list = list
		@main.clear do
			caption "Choose: (#{list.length})", align: "center"
			@list.each do |phrase| 
				item_url(phrase){ start_progression phrase }
			end
		end #main.clear
	end

	# a programmatic atom bomb. needs to be refactored!
	def start_progression phrase
		return false if $app.is_working

		Thread.new {			
			# Lock User Interactions
			$app.is_working = true
			# Save Last Search
			$app.save_last_request	
			# Write current search and Thumbnail
			$app.current_search = { phrase: phrase, thumbnail: $app.current_search[:thumbnail] }
			# Write the current phrase to search-edit-line
			$widgets.title_bar.write phrase
			# Draw wait Screen
			$widgets.mind_map.draw_wait_screen

			links = lookup_wikipedia_with phrase
			if links
				create_options_list_with links			
				create_thumbnail_with phrase, links
				draw_mindmap			
				check_easter_egg phrase
				success
			else
				nothing_found
			end
			# Unlock Userinteractions
			$app.is_working = false
		}
	end

	def lookup_wikipedia_with phrase
		$widgets.status_bar.set 0.1
		$widgets.status_bar.write "lookup wikipedia..."
		$app.data_controller.look_for phrase
	end

	def create_options_list_with links
		$widgets.status_bar.write "interpreting responses..."
		$widgets.status_bar.set 0.3
		$widgets.options_list.draw_normal links
	end

	def create_thumbnail_with phrase, links
		$widgets.status_bar.write "rendering mindmap..."
		$widgets.status_bar.set 0.6
		unless $app.current_search[:thumbnail]
			thumb =  $app.data_controller.render_thumbnail phrase, links
			$app.current_search[:thumbnail] = thumb
		end
	end

	def draw_mindmap
		$widgets.status_bar.write "loading new mindmap..."
		$widgets.status_bar.set 0.9
		$widgets.mind_map.draw_normal $app.current_search[:thumbnail]
	end

	def check_easter_egg phrase
		$widgets.mind_map.draw_pony_screen if phrase =~ /my little pony/i
		$widgets.mind_map.draw_pony_screen if phrase =~ /mein kleines pony/i
	end

	def success
		$widgets.status_bar.write "ready!"
		$widgets.status_bar.set 1.0
	end

	def nothing_found
		$widgets.status_bar.write "nothing found. try something else!"
		$widgets.status_bar.set 1.0
		$widgets.mind_map.draw_error_screen
		$widgets.options_list.draw_normal []
	end
end