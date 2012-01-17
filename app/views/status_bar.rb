#encoding: utf-8

class Shoes::StatusBar < Shoes::Widget
	attr_reader :prog, :msg

	def initialize start_text=""
		@main = flow width: 980, margin_left: 10, margin_top: 5
		@prog = 0.0
		@msg = start_text
		draw_normal
	end

	def draw_normal
		@main.clear do
			#@internet_status = internet_status
			#$DATA.internet_available? ? @internet_status.switch_on : @internet_status.switch_off
			@progress_bar = progress width: 700, fraction: @prog
			@message = para strong(@msg), size: 10, stroke: white
		end #main.clear
	end

	# Inkrementiert den Fortschritt der Progressbar um eine Größe number
	# number must be between 0.0 and 1.0
	def inc number
		@prog += number
		@progress_bar.fraction = @prog
	end

	def set number
		@prog = number
		@progress_bar.fraction = @prog
	end

	def write text
		@msg = text.to_s
		@message.text = @msg
	end

end