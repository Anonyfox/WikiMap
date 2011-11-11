#encoding: UTF-8

#Encoding.default_internal = "UTF-8"
#Encoding.default_external = "UTF-8"
#STDOUT.set_encoding "UTF-8"

require 'json'
require 'open-uri'
require 'uri'

module WikiClient

	def self.build_search_url str
		search = "http://de.wikipedia.org/w/api.php?action=opensearch" +
		"&format=json" +
		"&search=" + 
		URI.escape(str)
	end

	def self.build_query_url str
		query = "http://de.wikipedia.org/w/api.php?action=query" +
		"&format=json&prop=links&pllimit=500" +
		"&titles=" +
		URI.escape(str)
	end

	# get the list of topics
	def self.ask search_str
		search_url = self.build_search_url search_str
		h = open(search_url).read
		self.response_list JSON(h)
	end

	def self.response_list json
		return json[1]
	end

	def self.get query_str
		query_url = build_query_url query_str
		h = open(query_url).read
		response_links JSON(h)
	end

	def self.response_links json
		links = []
		json["query"]["pages"].each do |key, value|
			# there is only one entry with the page_id, 
			# so this runs just once
			value["links"].each do |hash|
				links.push hash["title"]
			end
		end
		return links
	end

end

#WikiClient.ask "penis" # => list of phrases
#WikiClient.get "Penis" # => links of this page