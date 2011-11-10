require 'active_record'
require_relative '../db/testbase.rb' #database settings

class Page < ActiveRecord::Base
	set_table_name :pages
	#set_primary_key :page_id

	has_many :links, :dependent => :destroy
end