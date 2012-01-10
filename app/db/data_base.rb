#encoding: utf-8

require 'active_record'
require 'sqlite3'
require_relative 'migrations/test_migration'

class DataBase
	def initialize
		# set up the database file, creates one if doesn't exist yet
		@home = ENV['HOME']
		@path = @home + "/.wikimap"
		Dir.mkdir @path unless Dir.exists? @path
		@name = @path + "/wikimap.db"
		@db = SQLite3::Database.new @name
		
		# fire off active record
		ActiveRecord::Base.establish_connection(
			:adapter => 'sqlite3', 
			:encoding => 'UTF-8',
			:database => @name
		)

		#load the AR Classes here
		require_relative '../models/page'

		# migrate if database is empty or incomplete
		migrate! 
	end

	def migrate!
		AddPageTable.migrate :up unless Page.table_exists?
	end

	def drop!
		AddPageTable.migrate :down
	end
end

if $0 == __FILE__
	db = DataBase.new
	db.drop!
	db.migrate!
end