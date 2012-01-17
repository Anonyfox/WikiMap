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
			return false if $IS_WORKING
			$STATUS_BAR.write "lookup wikipedia..."
			# Lock User Interactions
			$IS_WORKING = true
			# Check if Back-Button is pressed
			unless $BACK
				# Push the last search and thumbnail to stack
				$SEARCHED << $SEARCHED_LAST if $SEARCHED_LAST != {}
			end
			$BACK = false
			# if thumbnail not given => create path
			unless thumbnail
				$RESSOURCE_THUMBNAIL_PATH[1] = $IMAGE_COUNTER
				$CURRENT_MIND_MAP = $RESSOURCE_THUMBNAIL_PATH.join("")
			else
				$CURRENT_MIND_MAP = thumbnail
			end
			# Write current search and Thumbnail for next search to variable
			$SEARCHED_LAST = { phrase: name, thumbnail: $CURRENT_MIND_MAP }
			# Write the current phrase to search-edit-line
			$TITLE_BAR.write name
			# Draw wait Screen
			$MIND_MAP.draw_wait_screen
			$STATUS_BAR.set 0.1
			response = $CONTROLLER.look_for name
			if response
				# Print Link List
				$STATUS_BAR.write "interpreting responses..."
				$STATUS_BAR.set 0.3
				$OPTIONS_LIST.draw_normal response
				
				# Create Thumbnail
				$STATUS_BAR.write "rendering mindmap..."
				$STATUS_BAR.set 0.6
				unless thumbnail
					$IMAGE_COUNTER += 1
					$CONTROLLER.render name, response, $CURRENT_MIND_MAP
				end

				# Draw Mindmap
				$STATUS_BAR.write "loading new mindmap..."
				$STATUS_BAR.set 0.9
				$MIND_MAP.draw_normal $CURRENT_MIND_MAP
				
				# Successful
				$STATUS_BAR.write "ready!"
				$STATUS_BAR.set 1.0
			else #nothing found
				$STATUS_BAR.write "nothing found. try something else!"
				$STATUS_BAR.set 1.0
				$MIND_MAP.draw_error_screen
				$OPTIONS_LIST.draw_normal []
			end

			# Unlock Userinteractions
			$IS_WORKING = false
		}
	end
end