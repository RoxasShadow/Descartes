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
	class Tangorin
		include Cinch::Plugin

		match /!tangorin (.+)/, use_prefix: false
		def execute(m, search)
			begin
				page = Nokogiri::HTML open(URI.escape("http://tangorin.com/general/#{search}")).read, nil, 'utf-8'

				romaji = page.at_xpath('//rt').text.chop
				kana = page.at_xpath('//rb').text
				kanji = page.at_xpath('//span[@class="writing"]').text
				meaning = page.at_xpath('//span[@class="eng"]').text
				info = page.at_xpath('//i[@class="d-info"]').text.chop.downcase.tr("—","")
				
				m.reply "[Tangorin] #{kanji} (#{kana} - #{romaji}): #{meaning} (#{info})"
			rescue; end
		end
	end
end
