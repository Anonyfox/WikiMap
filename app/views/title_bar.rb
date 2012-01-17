#encoding: utf-8

class Shoes::TitleBar < Shoes::Widget
	attr_accessor :search_text

	def initialize start_string=nil
		@main = flow width: 980, margin_left: 10
		@search_text = start_string || ""
		draw_normal start_string
	end

	def draw_normal start_string=nil
		@main.clear do
			# Klick-Event des "Zurück"-Buttons
			button("<<") do
				if $wikimap.searched == []
					@search_text = ""
				else
					debug $wikimap.searched
					hash = $wikimap.searched.pop
					@search_text = hash[:phrase]
					@line.text = @search_text
					$wikimap.is_back_search = true
					if hash[:thumbnail] == $wikimap.mind_map.welcome_image
						process_search
					else
						$wikimap.options_list.render_and_save @search_text, hash[:thumbnail]
					end
				end
			end

			@line = edit_line width: 300, text: @search_text

			# Keypress-Event der Suchzeile
			@line.change do
				@search_text = @line.text
			end

			# Klick-Event des Suchbuttons
			button("search!") do
				process_search		
			end
			
			# Klick-Event des Random-Button
			button("Random") do
				draw_search_resuts WikiClient.random_pages
			end

			# Klick-Event des Exportbuttons
			button("export mindmap") do
				export_mindmap
			end

			button("Show in Browser") do
				visit "http://de.wikipedia.org/wiki/#{URI.encode($wikimap.searched_last)}"
			end

			# Klick-Event des Aboutbuttons
			button "about" do
				alert(
					"WikiMap© Version 1.0\n\n" +
					"Diese Software entstand in Zusammenarbeit von:\n" +
					"Sebastian Braune, Francesco Möller, Maximilian Stroh, Markus Herklotz, Josua Koshwitz\n\n" + 
					"Letztes Update: 17.01.2012"
				)
			end
		end #main.clear
	end

	# Search for a given string
	def lookup_text
		$wikimap.controller.search_matching_links_to @search_text
	end

	# print search_results to optionlist
	def draw_search_resuts items=[]
		$wikimap.options_list.draw_normal items
		$wikimap.mind_map.draw_welcome_screen
	end

	def export_mindmap
		return false if $wikimap.searched_last == {}
		return false if $wikimap.searched_last[:thumbnail] == $wikimap.mind_map.welcome_image
		target_file = ask_save_file
		return false unless target_file && target_file != ""
		$wikimap.controller.render(
			$wikimap.searched_last[:phrase],
			$wikimap.controller.look_for($wikimap.searched_last[:phrase]),
			target_file,
			false
		)
	end

	def process_search
		draw_search_resuts lookup_text
		save_last_search
	end

	def save_last_search
		# Check if Back-Button is pressed
		unless $wikimap.is_back_search
			# Push the last search and thumbnail to stack
			$wikimap.searched << $wikimap.searched_last if $wikimap.searched_last != {}	
		end
		$wikimap.is_back_search = false
		$wikimap.searched_last = { phrase: @search_text, thumbnail: $wikimap.mind_map.welcome_image }
	end

	def write text
		@line.text = text
		@search_text = text
	end

	def set_focus
		@line.focus
	end
end