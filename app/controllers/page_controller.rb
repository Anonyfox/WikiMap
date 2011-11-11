#encoding: utf-8

require_relative '../models/page'

class PageController
	attr_reader :phrase, :target_pages

	# create a new page. expects a phrase and a link list. opens an existing
	# page if there is one. 
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
	end

private

	# lists all pages the corresponding links are referring to
	def lookup_target_pages
		@targets.map {|page_id| Page.find page_id }
	end

	# resolves the given phrase, create an uncrawled page object
	def add_uncrawled_page name
		crawled_page = Page.where(phrase: name)[0]
		if crawled_page
			return crawled_page.id
		else
			new_page = Page.new phrase: name, crawled: false
			new_page.save
			return new_page.id
		end
	end

	def page_exists? phrase
		page = Page.where phrase: phrase
		page == [] ? false : true
	end

	def add_target_pages list
		list.map {|phrase| add_uncrawled_page(phrase) }
	end
end