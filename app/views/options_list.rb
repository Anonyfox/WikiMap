#encoding: utf-8

require_relative 'item_url'

class Shoes::OptionsList < Shoes::Widget
	attr_reader :list

	def initialize start_list=[]
		@list = start_list
		@main = stack width: 300, height: 680, scroll: true
		draw_normal start_list
	end

	def draw_normal list=[]
		@list = list
		@main.clear do
			caption "Choose: (#{list.length})", align: "center"
			@list.each do |name| 
				item_url(name){ render_and_save name }
			end
		end #main.clear
	end

	def render_and_save name, thumbnail=nil
		Thread.new {
			return false if $wikimap.is_working
			$wikimap.status_bar.write "lookup wikipedia..."
			# Lock User Interactions
			$wikimap.is_working = true
			# Check if Back-Button is pressed
			unless $wikimap.is_back_search
				# Push the last search and thumbnail to stack
				$wikimap.searched << $wikimap.searched_last if $wikimap.searched_last != {}
			end
			$wikimap.is_back_search = false
			# if thumbnail not given => create path
			unless thumbnail
				$wikimap.ressource_thumbnail_path[1] = $wikimap.image_counter
				$wikimap.current_mind_map = $wikimap.ressource_thumbnail_path.join("")
			else
				$wikimap.current_mind_map = thumbnail
			end
			# Write current search and Thumbnail for next search to variable
			$wikimap.searched_last = { phrase: name, thumbnail: $wikimap.current_mind_map }
			# Write the current phrase to search-edit-line
			$wikimap.title_bar.write name
			# Draw wait Screen
			$wikimap.mind_map.draw_wait_screen
			$wikimap.status_bar.set 0.1
			response = $wikimap.controller.look_for name
			if response
				# Print Link List
				$wikimap.status_bar.write "interpreting responses..."
				$wikimap.status_bar.set 0.3
				$wikimap.options_list.draw_normal response
				
				# Create Thumbnail
				$wikimap.status_bar.write "rendering mindmap..."
				$wikimap.status_bar.set 0.6
				unless thumbnail
					$wikimap.image_counter += 1
					$wikimap.controller.render name, response, $wikimap.current_mind_map
				end

				# Draw Mindmap
				$wikimap.status_bar.write "loading new mindmap..."
				$wikimap.status_bar.set 0.9
				$wikimap.mind_map.draw_normal $wikimap.current_mind_map
				
				# Successful
				$wikimap.status_bar.write "ready!"
				$wikimap.status_bar.set 1.0
			else #nothing found
				$wikimap.status_bar.write "nothing found. try something else!"
				$wikimap.status_bar.set 1.0
				$wikimap.mind_map.draw_error_screen
				$wikimap.options_list.draw_normal []
			end

			# Unlock Userinteractions
			$wikimap.is_working = false
		}
	end
end