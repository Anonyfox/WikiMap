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
		clear_temps
	end

	# get a list of possible links similar to the given name
	def search_matching_links_to name
		answer = nil
		if internet_available?
			answer = WikiClient.ask name
			answer.select! { |link| !(link =~ /:/) }
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
			answer.select! { |link| !(link =~ /:/) }
			@db[name] = answer
		else
			answer = @db[name]
		end
		answer || []
	end

	# produce an orginal mindmap export image in fileformat 'png'
	def render_picture root, links, destination
		WikiClient.generate_picture root, links, destination
	end

	# produce an compatible application resized thumbnail of the current mindmap
	def render_thumbnail root, links
		WikiClient.generate_thumbnail root, links
	end

	# clear all temp files in HOME/.wikimap/tmp directory
	def clear_temps
		WikiClient.clear_tmp_directory
	end

	# simply checks if internet is available by pinging google.com
	def internet_available?
		require 'net/ping/http'
		Net::Ping::HTTP.new("http://www.google.com").ping?
	end
end