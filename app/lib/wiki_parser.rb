#require 'uri'
require 'json'

module WikiParser

	def self.build_url(str)
		query = "de.wikipedia.org/w/api.php?action=opensearch" +
		"&format=json" +
		"&search=" + 
		URI.escape(str)
	end

	def self.get_pages(json_response)

	end

end