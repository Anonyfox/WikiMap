#encoding: utf-8

class Shoes::TitleBar < Shoes::Widget
	attr_accessor :search_text

	def initialize start_string=nil
		@main = flow width: 980, margin_left: 10
		@search_text = start_string || ""
		draw_titlebar start_string
	end

	def draw_titlebar start_string=nil
		@main.clear do
			button("<<") {
				if $SEARCHED == []
					@search_text = ""
				else
					@search_text = $SEARCHED.pop
					@line.text = @search_text
					lookup_text
				end
			}
			@line = edit_line width: 300, text: @search_text
			@line.change {
				@search_text = @line.text
			}
			button("search!") { lookup_text }
			button("export mindmap") {
				
			}
			button "help"
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