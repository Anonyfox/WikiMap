#encoding: utf-8

require 'fileutils'

module Init
	def self.on_startup(app)
		app.instance_eval do 
			# clear old cache
			FileUtils.rm Dir.glob("./tmp/*")

			# some simple global vars
			$picture_created = false
			$choices = nil
			$clicked = nil
			$answer = nil
			$last_choices = []
			$img_counter = 0
			$ERROR_TOO_MANY = Proc.new { 
				alert "sorry, too many items! (#{$answer.size})" 
			}

			# standard routines
			$redraw_options = Proc.new {|list=nil|
				$list_stack.clear {
					if list
						$choices = list
				  else
						$choices = WikiClient.ask $search.text
					end
					$choices.each {|name| item_url name }
				}
			}
			$update_state = Proc.new {|name|
				Thread.new {
					$update_progress.call 'looking...', 0.2
					$mindmap.waitscreen
					$clicked = name
					$last_choices << $clicked.dup
					$answer = WikiClient.get name
					$update_progress.call 'redraw options list...', 0.4
					$redraw_options.call $anwer
					$update_progress.call 'rendering mindmap...', 0.6
					WikiClient.output name, $answer, $img_counter# rescue alert "fail"
					$update_progress.call 'cleaning up...', 0.8
					$mindmap.update
					$picture_created ||= true
					$img_counter += 1
					$update_progress.call 'ready!', 1.0
				}
			}
			$update_progress = Proc.new {|message, value|
				$progress.fraction = value
				$progress_info.text = message
			}
		end
	end
end