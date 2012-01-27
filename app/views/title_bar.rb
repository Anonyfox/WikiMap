#encoding: utf-8

# The TitleBar-Widget contains the main control elements
# including the search-line. 
class Shoes::TitleBar < Shoes::Widget
	attr_accessor :search_text

	# define a new TitleBar Widget. You may or may not set a
	# default value for the application-startup, default is
	# none
	def initialize start_string=nil
		@main = flow width: 980, margin_left: 10
		draw_normal ( @search_text = start_string || "" )
	end

	# Renders the TitleBar Widget and all the nested Control
	# elements. You may set a default text for the search-line.
	def draw_normal start_string=nil
		@main.clear do
			button("<<") { turn_back }
			@line = edit_line(width: 300, text: @search_text) { @search_text = @line.text }
			button("search!") { process_search }
			button("Random"){ draw_search_results WikiClient.random_pages }
			button("export mindmap") { $app.export_mindmap }
			button("Show in Browser") { visit Phrases.url( $app.current_search[:phrase]) }
			button("about") { alert Phrases.about }
		end #main.clear
	end

	# Print search_results to optionlist.
	def draw_search_results items=[]
		$widgets.options_list.draw_normal items
		$widgets.mind_map.draw_welcome_screen
	end
	
	# Search links with the help of the correspondending
	# search string in the search bar.
	def lookup_text
		$app.data_controller.search_matching_links_to @search_text
	end

	# Refresh search results.
	def process_search
		# stores the last search results
		$app.save_last_request
		# Draw List
		draw_search_results lookup_text
		$app.current_search = { phrase: @search_text, thumbnail: nil }
	end

	# Update the text into the search-line.
	def write text
		@search_text = @line.text = text
	end

	# Set the application focus to the search-line.
	def set_focus
		@line.focus
	end

	# pop the item form the history and let it show.
	# this is a event-method for Back-Button.
	def turn_back
		search = $app.get_last_request
		write search[:phrase]
		$app.is_back_search = true
		if search[:thumbnail]
			$app.current_search = search
			$widgets.options_list.start_progression @search_text
		else
			process_search	
		end #if
	end
end