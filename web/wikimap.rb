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
	@items = WikiClient.get URI.decode(params["query"])
	mm_items = @items[0..200].map{|item|
		size = rand(6) + 1
		click = "function() {mm_get('#{URI.decode(item)}');}"
		"{text:\"#{item}\", weight:#{size}, handlers:{click:#{click}}}"
	}.join(",")
	str = "[" + mm_items + "]"
end