#encoding: utf-8

class Shoes::ItemUrl < Shoes::Widget

	def initialize name
		@name = name
		@main = flow width: 298, margin: 1
		draw_normal
		@main.hover { draw_hovered }
		@main.leave { draw_normal }
		@main.click {
			#Thread.new {
				$mindmap.waitscreen
				$clicked = @name
				$answer = WikiClient.get @name
				if $answer.size < 150
					# Create Output Picture
					WikiClient.output @name, $answer, $img_counter
					$mindmap.update
					$picture_created ||= true
					$img_counter += 1
				else
					$ERROR_TOO_MANY.call
				end
			#}
		}
	end

	def draw_normal
		@main.clear {
			para @name, size: 10
		}
	end

	def draw_hovered
		@main.clear {
			background cornflowerblue, curve: 5
			para @name, size: 10
		}
	end
end
