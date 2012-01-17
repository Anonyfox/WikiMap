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
				if $SEARCHED == []
					@search_text = {}
				else
					hash = $SEARCHED.pop
					@search_text = hash[:phrase]
					@line.text = @search_text
					$OPTIONS_LIST.render_and_save @search_text, hash[:thumbnail]
				end
			end

			@line = edit_line width: 300, text: @search_text

			# Keypress-Event der Suchzeile
			@line.change do
				@search_text = @line.text
			end

			# Klick-Event des Suchbuttons
			button("search!") do
				draw_option_list lookup_text
				$SEARCHED.push @search_text
			end
			
			# Klick-Event des Random-Button
			button("Random") do
				draw_option_list WikiClient.random_pages
			end

			# Klick-Event des Exportbuttons
			button("export mindmap") do
				target_file = ask_save_file
				return false unless target_file && target_file != ""
				$CONTROLLER.render(
					$SEARCHED_LAST,
					$CONTROLLER.look_for($SEARCHED_LAST),
					target_file,
					false
				)
			end

			button("Show in Browser") do
				visit "http://de.wikipedia.org/wiki/#{URI.encode($SEARCHED_LAST)}"
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

	# Sucht nach einem gegebenen Suchstring
	def lookup_text
		$CONTROLLER.search_matching_links_to @search_text
	end

	def draw_option_list items=[]
		$OPTIONS_LIST.draw_normal items
		$MIND_MAP.draw_welcome_screen
	end

	def write text
		@line.text = text
		@search_text = text
	end

	def set_focus
		@line.focus
	end
end