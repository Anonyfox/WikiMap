#encoding: UTF-8

class Shoes::MindMap < Shoes::Widget
	def initialize path=nil
		@wait_path = "./app/gfx/wait.png"
		@pic = path || @wait_path
		@main = flow width: 695
		waitscreen
	end

	def waitscreen
		@main.clear {
			image @wait_path, width: 690, height: 650
		}
	end

	def update
		@main.clear {
			image "./tmp/my_graph_#{$img_counter}.png", height: 650, width: 690
		}
	end
end
