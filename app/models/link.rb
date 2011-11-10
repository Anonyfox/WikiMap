require 'active_record'
require_relative '../db/testbase.rb' #database settings

class Link < ActiveRecord::Base
	set_table_name :links
	#set_primary_key :link_id

	belongs_to :page
end