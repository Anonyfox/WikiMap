#encoding: utf-8

Shoes.setup do
	gem 'graph'
end

require './app/lib/wiki_client'

Shoes.app title: "WikiMap", width: 820 do

	require './app/widgets/item_url'
	require './app/widgets/mind_map'

	#debug("ask: " + WikiClient.ask("xml").to_s)
	#debug("get: " + WikiClient.get("xml").to_s)

	flow do

		# title flow
		flow do
			@search = edit_line width: 500
			@go = button "search!"
			@go.click{ 
				@list_stack.clear {
					choices = WikiClient.ask @search.text
					choices.each {|name| item_url name }
				}
			}
		end #title flow
		
		# list stack
		@list_stack = stack width: 300

		# mindmap picture
		stack width: 500 do
			$mindmap = mind_map "empty"
		end

	end

	keypress do |k|

	end
	
end