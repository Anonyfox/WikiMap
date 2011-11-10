#require 'uri'
require 'json'
require 'open-uri'

module WikiParser

	def self.build_search_url(str)
		search = "http://de.wikipedia.org/w/api.php?action=opensearch" +
		"&format=json" +
		"&search=" + 
		URI.escape(str)
	end

	def self.build_query_url(str)
		query = "http://de.wikipedia.org/w/api.php?action=query" +
		"&format=json&prop=links&pllimit=500" +
		"&titles=" +
		URI.escape(str)
	end

	def self.get_pages(json_response)
		resp = JSON.parse json_response
		resp
	end

	def extract_phrase_of url
	end

end

#p WikiParser.build_search_url "penis"