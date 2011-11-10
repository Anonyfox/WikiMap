#encoding: utf-8

require_relative 'mind_map'
require_relative '../lib/wiki_client'

# This class is the main controller of the application. 
# it merges the WikiClient with the MindMap-Controller
# and organizes the views.
class WikiMap

	def initialize
	end

	def ask_wiki_for str
		list = false
		Thread.new do
			list = WikiClient.ask(str)
		end
		until list
			sleep 0.1
		end
		puts list
	end

	def crawl_page str
		list = false
		Thread.new do
			list = WikiClient.get str
		end
		until list
			sleep 0.1
		end
		puts list
	end

	def delete_page str
	end

private
	
	def get_page str
	end

	def page_exists? str
	end
end

w = WikiMap.new

###########################################
# function test for opensearch
###########################################
=begin
loop do
	puts "\n\nSuchbegriff?"
	q = gets.chomp
	break if q == "exit"
	puts "\nErgebnisse:\n"
	w.ask_wiki_for q
end
=end


###########################################
# function test for query
###########################################
loop do
	puts "\n\nSuchbegriff?"
	q = gets.chomp
	break if q == "exit"
	puts "\nErgebnisse:\n"
	w.crawl_page q
end