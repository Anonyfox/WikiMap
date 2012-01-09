#encoding: UTF-8

class Shoes::MindMap < Shoes::Widget
	def initialize str=nil
		@str = str || ""
		@main = flow width: 500 do
			border black
			para "Empty"
		end
	end

	def update
		@main.clear {
			border black
			image "tmp/my_graph.png"
		}
	end
end
