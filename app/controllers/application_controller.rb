#encoding: utf-8

require_relative 'page_controller'
require_relative '../lib/wiki_client'
require 'pp' #for structured test output

# This class is the main controller of the application. 
# it merges the WikiClient with the MindMap-Controller
# and organizes the views.
class ApplicationController

	def initialize
		draw_main_window
	end

	def ask_wiki_for str
		list = false
		Thread.new do
			list = WikiClient.ask(str)
			draw_options_list list
		end
		# testing helper
		until list
			sleep 0.1
		end
	end

	def crawl_page str
		list = false
		#Thread.new do
			list = WikiClient.get str
			pc = PageController.new phrase: str, links: list
			draw_mindmap pc.target_pages
		#end
		# testing helper
		until list
			sleep 0.1
		end
	end

	def draw_main_window
		puts "\n\nSuchbegriff?"
	end

	def draw_options_list params
		pp params
	end

	def draw_mindmap params
		pp params
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
