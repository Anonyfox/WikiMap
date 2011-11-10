#encoding: utf-8

#the main controller for the two models Page ans Link

require_relative '../models/link'
require_relative '../models/page'

class MindMap
	attr_reader :phrase

	# create a new page.
	def initialize params
		phrase = params[:phrase] || nil
		links = params[:links] || []
		return false unless phrase
		@page = Page.new phrase: phrase
		@page.save
		@links = []
		links.each {|l| add_link pg.id, l }
	end

	# open an existing page
	def get params

	end

	# update an existing page
	def edit params

	end

	# save this page to database
	def save params

	end

	# delete this page and all corresponding links
	def delete params

	end

	# lists all links of this page
	def links

	end

	# lists all pages the corresponding links are referring to
	def pages

	end

private

	def add_uncrawled_page name
		cp = Page.where phrase: name
		if cp
			return cp
		else
			Page.create do |pg|
				pg.phrase = name
			end
			return pg
		end
	end

	def add_link from, to
	end

	def delete_link from
	end

	def get_destination_of link
	end
end