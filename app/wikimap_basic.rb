#encoding: utf-8

################################################################
## A command-line tool for testing the logical modules #########
################################################################

require_relative "lib/gemlist.rb"
require_relative "lib/wiki_parser.rb"

#ask for query string
puts "WikiMap 0.0.1"
puts "============="
print "Bitte Phrase eingeben: "
search_str = gets.chomp

#research logic goes here
resp = WikiParser.build_url search_str

#response
puts resp