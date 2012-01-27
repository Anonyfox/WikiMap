#encoding: UTF-8

require 'json'
require 'open-uri'
require 'uri'
require_relative 'graph-viz-simple'
require 'fileutils'

# This standalone Module builds the correct URLs for requesting
# wikipedia, and implements the full http request to get the 
# results. 
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
		self.response_links JSON(h)
	end

	# just returns some random pages of wikipedia.
	def self.random_pages
		h = open("http://de.wikipedia.org/w/api.php?action=query&format=json&list=random&rnlimit=10").read
		links = self.random_links JSON(h)
		debug links
		links.select { |link| !(link =~ /:/) }
	end

	# Generate a Thumbnail from 'links' around a root node 'phrase'.
	# returns the destination Path.
	def self.generate_thumbnail phrase, links=[]	
		destination = ""

		# Destination Operations
		Dir.mkdir "#{ENV["HOME"]}/.wikimap/tmp" unless Dir.exists? "#{ENV["HOME"]}/.wikimap/tmp"
		filearray = Dir.entries "#{ENV["HOME"]}/.wikimap/tmp"
		destination = "#{ENV["HOME"]}/.wikimap/tmp/my_graph_#{filearray.size - 2}.png"

		mygraph = self.graph({
			phrase: phrase, 
			links: links, 
			graph: {"bgcolor" => "transparent", "size" => 6.25}, 
			node: {"color" => "white", "style" => "filled"}, 
			edge: {"arrowhead" => "vee"}
		})
		mygraph.output destination, "png", "fdp"

		destination
	end

	# Generate a exportable picture from 'links' around a root node 'phrase'.
	def self.generate_picture phrase, links=[], destination
		mygraph = self.graph({
			phrase: phrase, 
			links: links, 
			graph: {"bgcolor" => "transparent"}, 
			node: {"color" => "white", "style" => "filled"}, 
			edge: {"arrowhead" => "vee"}
		})
		mygraph.output destination, "png", "fdp"
	end

	# Clear all temp-files in tmp-directory.
	# this function shoeld be called once in the initialization-phase.
	def self.clear_tmp_directory
		FileUtils.remove_dir "#{ENV["HOME"]}/.wikimap/tmp", true
	end

private

	# Create a MindMap (or Graph) with a root node 'phrase' and chield-nodes 'links'.
	# The visual appearance can modify with graph, node and edge attributes.
	def self.graph params={}
		phrase = params[:phrase] || "phrase"
		links = params[:links] || []
		graph_name = params[:name] || "MindMap"

		graph = GraphvizSimple.new(graph_name)

		graph.graph_attributes = params[:graph] || {}
		graph.node_attributes = params[:node] || {}
		graph.edge_attributes = params[:edge] || {}

		# normalize phrase
		rphrase = phrase.gsub(/\W/, '_')
		rphrase.gsub!(/\A(\w)/) { "_#{$1}" }

		# Add nodes and edges
		graph.add_node rphrase, {"label" => phrase} #root

		links.uniq.each do |link|
			rlink = link.gsub(/\W/, '_')
			rlink.gsub!(/\A(\w)/) { "_#{$1}" }
			if rlink != rphrase
				# Add nodes
				graph.add_node rlink, {"label" => link}
				graph.add_edge rphrase, rlink
			end
		end

		graph
	end

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
		links
	end

	# a helper method to extract the neccessary data out
	# of the json-response
	def self.random_links json
		links = []
		json["query"]["random"].each do |value|
			links.push value["title"]
		end
		links
	end

end
