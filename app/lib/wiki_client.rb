#encoding: UTF-8

Encoding.default_internal = "UTF-8"
Encoding.default_external = "UTF-8"
STDOUT.set_encoding "UTF-8"

require_relative 'wiki_parser'
require 'open-uri'

module WikiClient

	# get the list of topics
	def self.ask search_str
		search_url = WikiParser.build_search_url search_str
		done = false
		Thread.new do 
			h = open(search_url).read
			puts JSON(h)
			p JSON(h)
			done = true
		end
		
		until done
			sleep 0.1
		end

	end

end

WikiClient.ask "penis"