#encoding: utf-8

class Shoes::InternetStatus < Shoes::Widget

	def initialize
		@main = flow width: 50, height: 50
	end

	def switch_on
		@main.clear { image "./app/gfx/internet_ok.png" }
	end

	def switch_off
		@main.clear { image "./app/gfx/no_internet.png" }
	end

end