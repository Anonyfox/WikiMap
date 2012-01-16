require 'active_record'
#require_relative '../db/testbase.rb' #database settings

# This Model-Class is widely empty, because the mighty
# activerecord library maps this class onto a database-table.
# no further configuration needed. Every Page Object has the
# following attributes: 
# - id # => the id of the page in the database
# - phrase # => a string with the name of the page
# - targets # => a comma-separated-id-string of the pages this page refers to
# - crawled # => just a boolean which knows if this page was crawled already or just created as a destination
# - created_at # => a timestamp
# - updated_at # => a timestamp
class Page < ActiveRecord::Base
	set_table_name :pages
end