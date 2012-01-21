#encoding: utf-8

# The Statusbar of the WikiMap Application. It contains a
# progressbar which can be controlled through the inc and set
# methods. There is also a little StatusText within, right to
# the progressbar. You may set the text of this StatusText 
# by using the write method. 
class Shoes::StatusBar < Shoes::Widget
	attr_reader :prog, :msg

  # creates a new Statusbar Widget, you may give it a StatusText
  # fo startup. It is 980px width.
	def initialize start_text=""
		main = flow width: 980, margin_left: 10, margin_top: 5 do
			@progress_bar = progress width: 700, fraction: (@prog ||= 0.0)
			@message = para strong(@msg ||= start_text), size: 10, stroke: white
		end
	end

	# Increments the statusbar by the given number. 
	# number must be a float between 0.0 and 1.0
	def inc number=0.0
		@progress_bar.fraction = (@prog += number)
	end

	# Set the fraction of the progressbar directly. 
	# number must be a float between 0.0 and 1.0
	def set number=0.0
		@progress_bar.fraction = @prog = number
	end

	# changes the text of the StatusBar. Remember that there
	# is not too much space to write full-blown texts!
	def write text=""
		@message.text = @msg = text.to_s
	end

end