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
			button("<<") do
				if $app.searched == []
					@search_text = ""
				else
					hash = $app.searched.pop
					@search_text = hash[:phrase]
					@line.text = @search_text
					$app.is_back_search = true
					if hash[:thumbnail] == $widgets.mind_map.welcome_image
						process_search
					else
						$widgets.options_list.render_and_save @search_text, hash[:thumbnail]
					end #if
				end #if
			end #button "<<"
			@line = edit_line(width: 300, text: @search_text) { @search_text = @line.text }
			button("search!") { process_search }
			button("Random"){ draw_search_results WikiClient.random_pages }
			button("export mindmap") { export_mindmap }
			button("Show in Browser") { visit Phrases.url( $app.searched_last[:phrase]) }
			button("about") { alert Phrases.about }
		end #main.clear
	end

	# Search for a given string
	def lookup_text
		$app.controller.search_matching_links_to @search_text
	end

	# print search_results to optionlist
	def draw_search_results items=[]
		$widgets.options_list.draw_normal items
		$widgets.mind_map.draw_welcome_screen
	end

	# render the full-screen MindMap to a target file.
	def export_mindmap
		return false if $app.searched_last == {}
		return false if $app.searched_last[:thumbnail] == $widgets.mind_map.welcome_image
		target_file = ask_save_file
		return false unless target_file && target_file != ""
		$app.controller.render(
			$app.searched_last[:phrase],
			$app.controller.look_for($app.searched_last[:phrase]),
			target_file,
			false
		)
	end

	# refresh search results
	def process_search
		draw_search_results lookup_text
		save_last_search
	end

	# stores the last search results
	def save_last_search
		# Check if Back-Button is pressed
		unless $app.is_back_search
			# Push the last search and thumbnail to stack
			$app.searched << $app.searched_last if $app.searched_last != {}	
		end
		$app.is_back_search = false
		$app.searched_last = { phrase: @search_text, thumbnail: $widgets.mind_map.welcome_image }
	end

	# update the text into the search-line
	def write text
		@search_text = @line.text = text
	end

	# set the application focus to the search-line
	def set_focus
		@line.focus
	end
end