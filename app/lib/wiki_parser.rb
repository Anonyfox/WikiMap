#require 'uri'
require 'json'

module WikiParser

	def self.build_url(str)
		query = "http://de.wikipedia.org/w/api.php?action=opensearch" +
		"&format=json" +
		"&search=" + 
		URI.escape(str)
	end

	def self.get_pages(json_response)
		resp = JSON.parse json_response
		resp
	end

end