#encoding: utf-8

# this is a very simple widget which contains just
# a background and a short text. if you hover over it, 
# the background will change and the text will be underlined
# the given block is the click-actionhandler. 
class Shoes::ItemUrl < Shoes::Widget

	# create a new item, giving it a name and an click-behaviour.
	def initialize name, &block
		@name = name
		@main = flow width: 298, margin: 1
		@main.hover { draw_hovered }
		@main.leave { draw_normal }
		@main.click { block.call }
		draw_normal
	end

private
	def draw_normal
		@main.clear {
			para @name, size: 10, leading: 1, margin: 2, margin_left: 10
		}
	end

	def draw_hovered
		@main.clear {
			background rgb(135,206,250,0.2), curve: 3
			para @name, size: 10, leading: 1, margin: 2, margin_left: 10, underline: 'single'
		}
	end
end
