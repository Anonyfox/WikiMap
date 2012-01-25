#encoding: utf-8

module Phrases

	# returns the url for the wikipedia-lookup in the browser
	def self.url phrase=""
		phrase = URI.encode phrase.to_s
		"http://de.wikipedia.org/wiki/#{phrase}"
	end

	# just contains the phrase shown when clicking
	# the about-button
	def self.about
		"WikiMap© Version 1.0\n\n" +
		"Diese Software entstand in Zusammenarbeit von:\n" +
		"Sebastian Braune, Francesco Möller, Maximilian Stroh, Markus Herklotz, Josua Koshwitz\n\n" + 
		"Letztes Update: 21.01.2012"
	end

	# dynamically count the lines of code of this app 
	def self.lines_of_code
		# TODO: count the lines of code of this app 
		# (exclude empty lines and comment-lines,
		# graph-viz-simple does not count as it is an external
		# library) 
		# ;)
	end
end