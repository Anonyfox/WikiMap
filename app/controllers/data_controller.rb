#encoding: utf-8

class DataController

	# the DataController handles all the loading/storing stuff. very easy.
	def initialize
		require 'kioku' #check out this awesome gem at rubygems.org ;)
		require_relative '../libs/wiki_client'
		@path = ENV['HOME'] + "/.wikimap"
		Dir.mkdir @path unless Dir.exists? @path
		Dir.mkdir @path+"/tmp" unless Dir.exists? @path+"/tmp"
		@db = Kioku.new @path + "/wikimap.db"
	end

	# get a list of possible links similar to the given name
	def search_matching_links_to name
		answer = nil
		if internet_available?
			answer = WikiClient.ask name
		else
			answer = @db.search name
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

	# wrapper for the original output method.
	def render root, links, destination, thumb=true
		WikiClient.output root, links, destination, thumb
	end

	# simply checks if internet is available by pinging google.com
	def internet_available?
		require 'net/ping/http'
		Net::Ping::HTTP.new("http://www.google.com").ping?
	end
end