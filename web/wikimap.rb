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
	@items = WikiClient.ask params["query"]
	haml :items
end

get '/get' do
	@items = WikiClient.get URI.decode(params["query"])
	haml :items
end