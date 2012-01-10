#encoding: utf-8

class Shoes::ItemUrl < Shoes::Widget

	def initialize name
		@name = name
		@main = flow width: 298, margin: 1
		draw_normal
		@main.hover { draw_hovered }
		@main.leave { draw_normal }
		@main.click { 
			$update_state.call @name
		}
	end

	def draw_normal
		@main.clear {
			para @name, size: 10, leading: 1
		}
	end

	def draw_hovered
		@main.clear {
			background cornflowerblue, curve: 5
			para @name, size: 10, leading: 1
		}
	end
end
