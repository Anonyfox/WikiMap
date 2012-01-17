# encoding: utf-8

# This class contains the table description inside the 
# database. 
# Just run this script to create the correct table
class AddPageTable < ActiveRecord::Migration
	# create the table :pages.
	def self.up
		create_table :pages do |t|
			t.string :phrase
			t.text :targets, default: "" #csv-like ID-list
			t.boolean :crawled
			t.timestamps
		end
	end

	# Delete the whole :pages table. All data will be lost!
	def self.down
		drop_table :pages
	end
end
