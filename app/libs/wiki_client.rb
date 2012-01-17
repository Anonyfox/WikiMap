#encoding: UTF-8

#Encoding.default_internal = "UTF-8"
#Encoding.default_external = "UTF-8"
#STDOUT.set_encoding "UTF-8"

require 'json'
require 'open-uri'
require 'uri'
require_relative 'graph-viz-simple'

# This standalone Module builds the correct URLs for requesting
# wikipedia, and implements the full http request to get the 
# results. 
# 
module WikiClient

	# Request the given URL, get the page content, format the
	# stuff to JSON and return the wanted informations as Array
	def self.ask search_str
		search_url = self.build_search_url search_str
		h = open(search_url).read
		self.response_list JSON(h)
	end

	# Request the given URL, parse the response to JSON, and return 
	# the wanted phrases as an Array
	def self.get query_str
		query_url = build_query_url query_str
		h = open(query_url).read
		response_links JSON(h)
	end

	def self.output phrase, links=[], destination=nil, img_counter=0, thumbnail=true
		destination ||= "./tmp/my_graph_#{img_counter}.png"
		graph = GraphvizSimple.new("MindMap")

		graph.edge_attributes = {"arrowhead" => "vee"}
		graph.graph_attributes = {"bgcolor"=>"transparent"}
		
		# normalize phrase
		rphrase = phrase.gsub(/\W/, '_')
		rphrase.gsub!(/\A(\w)/) { "_#{$1}" }

		# Add nodes and edges
		graph.add_node rphrase, {"label" => phrase} #root
		links.delete rphrase # no self links
		links.uniq.each do |link|
			rlink = link.gsub(/\W/, '_')
			rlink.gsub!(/\A(\w)/) { "_#{$1}" }
			# Add nodes
			begin
				graph.add_node rlink, {"label" => link}
				graph.add_edge rphrase, rlink
			rescue => e
				debug e
			end
		end

		if thumbnail
			graph.graph_attributes= {"size" => 6.25}
		end

		graph.output destination, "png", "fdp"
	end

private

	# build a valid request-url with the given string. this url
	# should be used to find matching topics to the given string
	def self.build_search_url str
		search = "http://de.wikipedia.org/w/api.php?action=opensearch" +
		"&format=json" +
		"&search=" + 
		URI.escape(str)
	end

	# build a valid request-url with the given string. if this string
	# is not a valid Wikipedia-Topic, you will get errors later! 
	# Best Practise is to use one of the Strings returned by the
	# search-request. this url should be used to get all links of
	# a topic
	def self.build_query_url str
		query = "http://de.wikipedia.org/w/api.php?action=query" +
		"&format=json&prop=links&pllimit=500" +
		"&titles=" +
		URI.escape(str)
	end

	# a helper method to extract the Names-list of the JSON-object
	# of the ask method
	def self.response_list json
		return json[1]
	end

	# the helper method of of WikiClient.get, which extracts
	# the wanted links from the JSON-Object and returns
	# them as an Array
	def self.response_links json
		links = []
		json["query"]["pages"].each do |key, value|
			# there is only one entry with the page_id, 
			# so this runs just once. a simple workaround
			(value["links"] || []).each do |hash|
				links.push hash["title"]
			end
		end
		return links
	end

end

#WikiClient.ask "penis" # => list of phrases
#WikiClient.get "Penis" # => links of this page