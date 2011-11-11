#encoding: utf-8

require_relative '../models/page'

class PageController
	attr_reader :phrase, :target_pages, :target_page_names

	# create a new page. expects a phrase and a link list. opens an existing
	# page if there is one. The link list is optional.
	# sample call:
	# - pc = PageController.new phrase: my_phrase, links: ["link_1", "link_2"]
	# 
	# in the :target_pages attribute stands an array of Page-Objects.
	# if you just want the names, just use the :target_page_names 
	# attribute.
	def initialize params
		phrase = params[:phrase] || nil
		links = params[:links] || []
		return false unless phrase

		if page_exists? phrase
			@page = Page.where(phrase: phrase)[0]
			if @page.crawled
				# TODO: recrawl here if old informations
				@targets = @page.targets.split(",")
			else
				@targets = add_target_pages(links)
				@page.targets = @targets.join ","
				@page.save
			end

		else #create a new page
			@page = Page.new phrase: phrase, crawled: true
			@targets = add_target_pages(links)
			@page.targets = @targets.join ","
			@page.save
		end
		@target_pages = lookup_target_pages
		@target_page_names = @target_pages.map{|pg| pg.phrase}
	end

private

	# lists all pages the corresponding links are referring to
	def lookup_target_pages
		@targets.map {|page_id| Page.find page_id }
	end

	# add a new page with the givem phrase and return its id. If a
	# page with this phrase is existing yet, just take this one and
	# return its id.
	def add_uncrawled_page name
		crawled_page = Page.where(phrase: name)[0]
		if crawled_page #take this one
			return crawled_page.id
		else #create a new page
			new_page = Page.new phrase: name, crawled: false
			new_page.save
			return new_page.id
		end
	end

	# simply check if there is a page with the given phrase
	def page_exists? phrase
		page = Page.where phrase: phrase
		page == [] ? false : true
	end

	# go through the given phrases-array, lookup the pages, 
	# create pages which are missing, and return a complete
	# array of all the page objects.
	def add_target_pages list=[]
		list.map {|phrase| add_uncrawled_page(phrase) }
	end
end