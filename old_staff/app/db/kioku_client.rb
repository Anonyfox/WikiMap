#encoding: utf-8

class DataBase
	attr_reader :db

	def initialize
		# set up the database file, creates one if doesn't exist yet
		@home = ENV['HOME']
		@path = @home + "/.wikimap"
		Dir.mkdir @path unless Dir.exists? @path
		@name = @path + "/wikimap.db"
		@db = Kioku.new @name
	end

	def drop!
		@db.clear
	end

	def store key, dataset

	end

	def exists? key

	end

	def get key

	end
end

if $0 == __FILE__
	db = DataBase.new
	db.drop!
end