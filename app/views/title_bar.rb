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
					@search_text = ""
				else
					@search_text = $SEARCHED.pop
					@line.text = @search_text
					lookup_text
				end
			end

			@line = edit_line width: 300, text: @search_text

			# Keypress-Event der Suchzeile
			@line.change do
				@search_text = @line.text
			end

			# Klick-Event des Suchbuttons
			button("search!") do
				lookup_text
				$SEARCHED.push @search_text
			end

			# Klick-Event des Exportbuttons
			button("export mindmap") do
			end

			# Klick-Event des Helpbuttons
			button "help" do
			end

			# Klick-Event des Aboutbuttons
			button "about" do
			end
		end #main.clear
	end

	# Sucht nach einem gegebenen Suchstring
	def lookup_text
		response = $CONTROLLER.search_matching_links_to @search_text
		$OPTIONS_LIST.draw_normal response
	end

	def write text
		@line.text = text
		@search_text = text
	end
end