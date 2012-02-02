#!/usr/bin/env ruby
# encoding: utf-8

require 'sinatra'
require 'haml'
require 'uri'
require_relative '../app/libs/wiki_client'

get '/' do
	haml :index
end

get '/ask' do
	@items = WikiClient.ask URI.decode(params["query"])
	haml :items
end

get '/get' do
	@items = WikiClient.get URI.decode(params["query"])
	haml :items
end

get '/get_mm_data' do
	query = URI.decode params["query"]
	@items = WikiClient.get query
	mm_items = @items[0..200].map{|item|
		size = rand(6) + 1
		click = "function() {wiki_get('#{URI.decode(item)}');}"
		"{text:\"#{item}\", weight:#{size}, handlers:{click:#{click}}}"
	}.join(",")
	str = "[" + mm_items + "]"
end

get '/get_random_pages' do
	@items = WikiClient.random_pages
	haml :items
end

get '/about' do
	haml :about
end

get '/download' do
	filename = 'WikiMap.shy.tar.gz'
	@path = File.expand_path(__FILE__.to_s).split("/")[0..-2].join("/") + "/download/"
	send_file @path+filename, :filename => filename, :type => 'Application/octet-stream'
end