#encoding: utf-8

#the main controller for the two models Page ans Link

require_relative '../models/link'
require_relative '../models/page'
require_relative '../lib/wiki_client'

class MindMap
	attr_reader :phrase, :target_pages

	# create a new page. expects a phrase and a link list
	def initialize params
		phrase = params[:phrase] || nil
		links = params[:links]
		return false unless phrase
		@page = Page.new phrase: phrase, crawled: true
		@page.save
		@links = []
		links.each {|l| add_link pg.id, l }
		@target_pages = pages
	end

	# open an existing page. needs the id or the correct phrase
	def get params={}
		id = params[:id] || nil
		phrase = params[:phrase] || nil
		return false unless id || phrase
		if id
			return Page.find id
		else
			return Page.where phrase: phrase
		end
	end

	# delete this page and all corresponding links
	def delete params
		id = @page.id
		Page.delete id
		links = Link.where from: id
		links.each {|l| Link.delete l.id}
	end

private

	# lists all pages the corresponding links are referring to
	def pages
		@links.each do |link|
			pg = Page.find link.to
			@pages.push pg.phrase
		end
	end

	# resolves the given phrase, create an uncrawled page object
	def add_uncrawled_page name
		cp = Page.where phrase: name
		if cp
			return cp
		else
			Page.create do |pg|
				pg.phrase = name
				pg.crawled = false
			end
			return pg
		end
	end

	# from is the id of the current page, 
	# to is the phrase of the target page
	def add_link from, to
		to_id = add_uncrawled_page.id
		link = Link.create do |l|
			l.from = from
			l.to = to_id
		end
		@links.push link
	end

	def delete_links from
		@links.each {|l| Link.delete l.id}
		@links = []
	end

	def get_destination_of link
	end
end