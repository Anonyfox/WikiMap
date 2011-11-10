require 'active_record'

ActiveRecord::Base.establish_connection(
	adapter: 'jdbcsqlite3',
	database: 'wikimap.db',
	#username: 'wikimapper',
	#password: '',
	#host: 'localhost',
	timeout: 5000
)