require 'active_record'
require 'sqlite3'

# Note: to use sqlite3 instead, just un/comment these two
# configurations!

####################################################
## Ruby/Shoes connector

dir_home = ENV['HOME']
db_path = dir_home + "/.wikimap"
Dir.mkdir db_path unless File.exists? db_path

unless File.exists? db_path + "/wikimap.db"
	SQLite3::Database.new db_path + "/wikimap.db"
end

ActiveRecord::Base.establish_connection(
	:adapter => 'sqlite3', 
	:encoding => 'UTF-8',
	:database => (ENV['HOME'] + "/.wikimap/wikimap.db")
)

AddPageTable.migrate :up unless Page.table_exists?

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