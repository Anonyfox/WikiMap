#encoding: UTF-8

class Shoes::MindMap < Shoes::Widget
	def initialize path=nil
		@welcome_image = "./app/gfx/welcome_screen.png"
		@wait_image = "./app/gfx/wait_screen.png"
		@error_image = "./app/gfx/error_screen_png"
		@pic = path || @welcome_image
		@main = flow width: 600, height: 600
		draw_normal
	end

	def draw_normal image_path=nil
		@main.clear do
			background white .. plum, angle: 90
			border black
			@pic = image_path if image_path
			image @pic, height: 600, width: 600
		end
	end

	def draw_welcome_screen
		draw_normal @welcome_image
	end

	def draw_wait_screen
		draw_normal @wait_image
	end

	def draw_error_screen
		draw_normal @error_image
	end
end
