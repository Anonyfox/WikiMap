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
	end

	def crawl_page str
	end

	def delete_page str
	end

private
	
	def get_page str
	end

	def page_exists? str
	end
end