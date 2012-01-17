#encoding: utf-8

require_relative 'page_controller'
require_relative '../lib/wiki_client'
require 'pp' #for structured test output

# This class is the main controller of the application. 
# it merges the WikiClient with the PageController
# and organizes the views.
class ApplicationController

	# This Action creates the main window, an sets everything
	# ready-to-use
	def initialize
		draw_main_window
	end

	# look into wikipedia if the given string matches any topics,
	# return an array of topics, and update the gui with the results
	def ask_wiki_for str
		list = false
		Thread.new do
			list = WikiClient.ask(str)
			draw_options list
		end
		# testing helper, remove this if the gui is used
		until list
			sleep 0.1
		end
	end

	# Go to the site which matches the given string, extract all the links
	# from there, update the database with the new stuff, and 
	# finally update the gui with the results
	def crawl_page str
		list = false
		#Thread.new do
			list = WikiClient.get str
			pc = PageController.new phrase: str, links: list
			draw_mindmap pc.target_pages
		#end
		# testing helper, remove this if the gui is used
		until list
			sleep 0.1
		end
	end

	# Draw the main window and set the gui elements ready-to-use
	def draw_main_window
		puts "\n\nSuchbegriff?"
	end

	# Update the View of the options_list with the given
	# informations. This method takes different arguments depending
	# on the current use-case. When you just want to show your 
	# results, 
	# - ApplicationControllerInstance.draw_options list: [...]
	# But if you want to show a special page, use
	# - ApplicationControllerInstance.draw_options site: "my_site"
	# where "my_site" can be one of the following special sites: 
	# - "500" # => an Error Page
	# - "404" # => Nothing found
	def draw_options params
		pp params
	end

	# Print all the found keywords as klickable text (=links) in 
	# a nice formatted list. This method expects an Array of Page-
	# Objects.
	def draw_mindmap ary=[]
		pp ary
	end
end

w = ApplicationController.new

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
#=begin
#pg = Page.find(2)
#pg.delete
loop do
	q = gets.chomp
	break if q == "exit"
	puts "\nErgebnisse:\n"
	w.crawl_page q
end
#=end
