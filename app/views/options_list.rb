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
			return false if $app.is_working
			$widgets.status_bar.write "lookup wikipedia..."
			# Lock User Interactions
			$app.is_working = true
			# Check if Back-Button is pressed
			unless $app.is_back_search
				# Push the last search and thumbnail to stack
				$app.searched << $app.searched_last if $app.searched_last != {}
			end
			$app.is_back_search = false
			# if thumbnail not given => create path
			unless thumbnail
				$app.ressource_thumbnail_path[1] = $app.image_counter
				$app.current_mind_map = $app.ressource_thumbnail_path.join("")
			else
				$app.current_mind_map = thumbnail
			end
			# Write current search and Thumbnail for next search to variable
			$app.searched_last = { phrase: name, thumbnail: $app.current_mind_map }
			# Write the current phrase to search-edit-line
			$widgets.title_bar.write name
			# Draw wait Screen
			$widgets.mind_map.draw_wait_screen
			$widgets.status_bar.set 0.1
			response = $app.controller.look_for name
			if response
				# Print Link List
				$widgets.status_bar.write "interpreting responses..."
				$widgets.status_bar.set 0.3
				$widgets.options_list.draw_normal response
				
				# Create Thumbnail
				$widgets.status_bar.write "rendering mindmap..."
				$widgets.status_bar.set 0.6
				unless thumbnail
					$app.image_counter += 1
					$app.controller.render name, response, $app.current_mind_map
				end

				# Draw Mindmap
				$widgets.status_bar.write "loading new mindmap..."
				$widgets.status_bar.set 0.9
				$widgets.mind_map.draw_normal $app.current_mind_map
				
				# Successful
				$widgets.status_bar.write "ready!"
				$widgets.status_bar.set 1.0
			else #nothing found
				$widgets.status_bar.write "nothing found. try something else!"
				$widgets.status_bar.set 1.0
				$widgets.mind_map.draw_error_screen
				$widgets.options_list.draw_normal []
			end

			# Unlock Userinteractions
			$app.is_working = false
		}
	end
end