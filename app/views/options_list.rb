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
			caption "Choose: ", align: "center"
			@list.each do |name| 
				item_url(name){ render_and_save name }
			end
		end #main.clear
	end

	def render_and_save name
		#Thread.new {
		return false if $IS_WORKING
		$STATUS_BAR.write "lookup wikipedia..."
		$IS_WORKING = true
		$SEARCHED << $SEARCHED_LAST if $SEARCHED_LAST
		$SEARCHED_LAST = name
		$TITLE_BAR.write name
		$MIND_MAP.draw_wait_screen
		$STATUS_BAR.set 0.1
		response = $CONTROLLER.look_for name
		if response
			$STATUS_BAR.write "interpreting responses..."
			$STATUS_BAR.set 0.3
			$OPTIONS_LIST.draw_normal response

			$STATUS_BAR.write "rendering mindmap..."
			$STATUS_BAR.set 0.6
			#Thumbnails
			$RESSOURCE_THUMBNAIL_PATH[1] = $IMAGE_COUNTER
			$CURRENT_MIND_MAP = $RESSOURCE_THUMBNAIL_PATH.join("")
			$IMAGE_COUNTER += 1
			$CONTROLLER.render name, response, $CURRENT_MIND_MAP

			$STATUS_BAR.write "loading new mindmap..."
			$STATUS_BAR.set 0.9
			$MIND_MAP.draw_normal $CURRENT_MIND_MAP

			$STATUS_BAR.write "ready!"
			$STATUS_BAR.set 1.0
		else #nothing found
			$STATUS_BAR.write "nothing found. try sth else!"
			$STATUS_BAR.set 1.0
			$MIND_MAP.not_found
			$OPTIONS_LIST.draw_options []
		end
		$IS_WORKING = false
		#}
	end
end