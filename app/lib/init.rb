#encoding: utf-8

require 'fileutils'

module Init
	def self.on_start
		FileUtils.rm Dir.glob("./tmp/*")
	end
end