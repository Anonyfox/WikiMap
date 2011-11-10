require 'active_record'
require_relative '../testbase.rb'

class AddLinkTable < ActiveRecord::Migration
	def self.up
		create_table :links do |t|
			t.integer :from
			t.integer :to
			t.timestamps
		end
	end

	def self.down
		drop_table :links
	end
end

class AddPageTable < ActiveRecord::Migration
	def self.up
		create_table :pages do |t|
			t.string :phrase
			t.boolean :crawled
			t.timestamps
		end
	end

	def self.down
		drop_table :pages
	end
end

#=begin
#AddLinkTable.migrate :down
#AddPageTable.migrate :down
AddLinkTable.migrate :up
AddPageTable.migrate :up
#=end