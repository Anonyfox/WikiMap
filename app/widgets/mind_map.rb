#encoding: UTF-8

class Shoes::MindMap < Shoes::Widget
	def initialize str=nil
		@str = str || ""
		@main = flow width: 500
		update
	end

	def update str=nil
		@main.clear {
			border black
			para (str || @str).to_s
		}
	end
end
