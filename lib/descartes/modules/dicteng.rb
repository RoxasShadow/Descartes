# encoding: UTF-8
##
###            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
###                    Version 2, December 2004
### 
### Everyone is permitted to copy and distribute verbatim or modified
### copies of this license document, and changing it is allowed as long
### as the name is changed.
### 
###            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
###   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
### 
###  0. You just DO WHAT THE FUCK YOU WANT TO.

require 'nokogiri'
require 'open-uri'

class Descartes
	class Dicteng
		include Cinch::Plugin

		match /!dict ([a-zA-Z]+) ([a-zA-Z]+)/, use_prefix: false

		def execute(m, action, word)
			url  = "http://www.wordreference.com/#{action}/#{word}"
			page = Nokogiri::HTML open(url)
			m.reply "#{page.xpath('//table[@class="WRD"]/tr[2]').text}  di più qui: #{url}"
		end
	end
end
