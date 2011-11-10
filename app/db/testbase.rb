require 'active_record'

ActiveRecord::Base.establish_connection(
	adapter: 'jdbcpostgresql',
	database: 'wikimap',
	username: 'wikimapper',
	password: '',
	host: 'localhost'
)