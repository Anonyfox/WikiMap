#encoding: utf-8

class Shoes::TitleBar < Shoes::Widget
	attr_accessor :search_text

	def initialize start_string=nil
		@main = flow width: 980, margin_left: 10
		@search_text = start_string || ""
		draw start_string
	end

	def draw start_string=nil
		@main.clear do
			# Klick-Event des "Zurück"-Buttons
			button("<<") begin
				if $SEARCHED == []
					@search_text = ""
				else
					@search_text = $SEARCHED.pop
					@line.text = @search_text
					lookup_text
				end
			end
			
			@line = edit_line width: 300, text: @search_text

			# Keypress-Event der Suchzeile
			@line.change begin
				@search_text = @line.text
			end

			# Klick-Event des Suchbuttons
			button("search!") begin
				lookup_text
				$SEARCHED.push @search_text
			end

			# Klick-Event des Exportbuttons
			button("export mindmap") begin
				
			end

			# Klick-Event des Helpbuttons
			button "help"

			# Klick-Event des Aboutbuttons
			button "about"
		end #main.clear
	end

	def lookup_text
		response = $DATA.search_matching_links_to @search_text
		$OPTIONS_LIST.draw_options response
	end

	def write text
		@line.text = text
		@search_text = text
	end
end