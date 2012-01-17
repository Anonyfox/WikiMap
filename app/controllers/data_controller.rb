#encoding: utf-8

class DataController

	# the DataController handles all the loading/storing stuff. very easy.
	def initialize
		require 'kioku'
		require_relative '../libs/wiki_client'

		@home = ENV['HOME']
		@path = @home + "/.wikimap"
		Dir.mkdir @path unless Dir.exists? @path
		@name = @path + "/wikimap.db"
		@db = Kioku.new @name
	end

	# get a list of possible links similar to the given name
	def search_matching_links_to name
		answer = nil
		if internet_available?
			answer = WikiClient.ask name
		else
			# TODO: Regular Expression auf den Key-Value-Store
		end
		answer || []
	end

	# returns the requested data for the given name
	def look_for name
		answer = nil
		if internet_available?
			answer = WikiClient.get name
			@db[name] = answer
		else
			answer = @db[name]
		end
		answer || []
	end

	def render root, links, destination
		WikiClient.output root, links, destination
	end

	# simply checks if internet is available by pinging google.com
	def internet_available?
		require 'net/ping/http'
		# google is the most solid test target
		http = Net::Ping::HTTP.new("http://www.google.com")
		http.ping? #? true : false
	end
end