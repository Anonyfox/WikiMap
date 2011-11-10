#encoding: utf-8

################################################################
## A command-line tool for testing the logical modules #########
################################################################

require_relative "lib/gemlist"
require_relative "lib/wiki_parser"

#ask for query string
puts "WikiMap 0.0.1"
puts "============="
#print "Bitte Phrase eingeben: "
#search_str = gets.chomp

#research logic goes here
#resp = WikiParser.build_url search_str

#response
#puts resp

#pg = Page.new phrase: "Suchmaschinen"
#pg.save
pg = Page.new phrase: "Suchmaschine"
pg.save
pg.links.create Link.new
pg.save


p pg

#l = Link.new from: pg.id
#l.save
#p l