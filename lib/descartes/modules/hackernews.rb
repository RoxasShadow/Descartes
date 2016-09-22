##
##            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
##                    Version 2, December 2004
##
## Everyone is permitted to copy and distribute verbatim or modified
## copies of this license document, and changing it is allowed as long
## as the name is changed.
##
##            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
##   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
##
##  0. You just DO WHAT THE FUCK YOU WANT TO.
###

require 'open-uri'
require 'nokogiri'

class Descartes
	class Hackernews
		include Cinch::Plugin

		match /(https?:\/\/news.ycombinator.com\/item\?id=[0-9]+)/, use_prefix: false
		def execute(m, url)
			begin
				page = Nokogiri::HTML open(url).read, nil, 'utf-8'

				title = page.at_xpath('//td[@class="title"]/a').text.to_s
				info = page.at_xpath('//td[@class="subtext"]').text.to_s.strip
				comments = info.match(/[0-9]+.comments/).to_s
				info = info.gsub(/\|.*/, "").rstrip
				
				m.reply "[HN] #{title} | #{info} | #{comments}"
			rescue; end
		end
	end
end
