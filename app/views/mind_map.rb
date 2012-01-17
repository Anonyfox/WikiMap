#encoding: UTF-8

class Shoes::MindMap < Shoes::Widget
	attr_reader :image_counter

	def initialize path=nil
		@welcome = "./app/gfx/welcome_screen.png"
		@wait = "./app/gfx/wait_screen.png"
		@pic = path || @welcome
		@main = flow width: 600, height: 600
		@image_counter = 0
		welcome_screen
	end

	def welcome_screen
		@main.clear {
			image @welcome, width: 600, height: 600
		}
	end

	def wait_screen
		@main.clear {
			image @wait, width: 600, height: 600
		}
	end

	def update
		@main.clear {
			background white .. plum, angle: 90
			border black
			image "./tmp/my_graph_#{@image_counter}.png", height: 600, width: 600
			@image_counter += 1
		}
	end
end
