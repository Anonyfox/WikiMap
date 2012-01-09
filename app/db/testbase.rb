require 'active_record'

# Note: to use sqlite3 instead, just un/comment these two
# configurations!

####################################################
## Ruby/Shoes connector

ActiveRecord::Base.establish_connection(
	:adapter => 'sqlite3', 
	:encoding => 'UTF-8',
	:database => 'wikimap'
)


####################################################
## Jruby connector
=begin
ActiveRecord::Base.establish_connection(
	adapter: 'jdbcpostgresql',
	database: 'wikimap',
	username: 'wikimapper',
	password: '',
	host: 'localhost',
)
=end

=begin
ActiveRecord::Base.establish_connection(
	adapter: 'jdbcsqlite3',
	database: 'wikimap.db',
	timeout: 5000
)
=end