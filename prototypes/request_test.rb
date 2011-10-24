Shoes.setup do 
	gem 'json'
	#gem 'open-uri'
end

require "../app/lib/wiki_parser"

Shoes.app height: 400, width: 600, title: "Wiki Request Test" do
	stack do
		flow margin_left: 50 do
			@q = edit_line width: 100
			@b = button "GO!"
		end
		@res = stack
	end

	@b.click do
		query = @q.text
		wiki_url = WikiParser.build_url query
		debug wiki_url
		download wiki_url do |wp|
			#alert wp.response.body.to_s
		end
	end

end