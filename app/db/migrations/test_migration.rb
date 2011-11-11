require 'active_record'
require_relative '../testbase.rb'

class AddPageTable < ActiveRecord::Migration
	def self.up
		create_table :pages do |t|
			t.string :phrase
			t.text :targets, default: "" #csv-like ID-list
			t.boolean :crawled
			t.timestamps
		end
	end

	def self.down
		drop_table :pages
	end
end

#=begin
AddPageTable.migrate :down
AddPageTable.migrate :up
#=end