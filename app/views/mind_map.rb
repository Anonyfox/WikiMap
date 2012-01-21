#encoding: UTF-8

# This simple widget is a kind of container, it
# simply shows images. Remember that you can show any special
# picture (error screen, load screen, ...) by just calling
# <code> mm.draw_#{name}_screen</code>. 
# 
class Shoes::MindMap < Shoes::Widget

	# instance a new MindMap widget. you may set a startup-image,
	# but the default is to use /app/gfx/welcome_screen.png
	def initialize path=nil
		@pic = path || self.send(:welcome_image)
		@main = flow width: 600, height: 600
		draw_normal
	end

	# redraw the image with the given (new) path. use this method
	# to switch the image shown.
	def draw_normal image_path=nil
		@main.clear do
			background white .. plum, angle: 90
			border black
			@pic = image_path if image_path
			image @pic, height: 600, width: 600
		end
	end

	# define some methods for special screens dynamically, 
	# this means a getter and a draw method for each picture
	[
		:welcome,
		:wait,
		:error,
		:pony
	].each do |scr| 
		define_method("#{scr}_image"){ "./app/gfx/#{scr}_screen.png" }
		define_method("draw_#{scr}_screen"){ draw_normal( self.send("#{scr}_image".to_sym) ) }
	end #each

	# note: 
	# the solution above contains way too much writing and explicit
	# definitions. if the number of pictures rises, move this stuff
	# into a method_missing hook. As we are just testing now, 
	# it is okay to allow explicit certain pictures, but this is
	# not an elegant dynamic solution! Worth to say that even this
	# current solution is way more flexible than everything you
	# could achieve with the .NET framework ;)
end
