#encoding: utf-8

class Shoes::ItemUrl < Shoes::Widget

	def initialize name, &block
		@name = name
		@main = flow width: 298, margin: 1
		@main.hover { draw_hovered }
		@main.leave { draw_normal }
		@main.click { block.call }
		draw_normal
	end

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
