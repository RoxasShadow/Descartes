##
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
##

require 'open-uri'
require 'nokogiri'

class Descartes
  class MusicToughts
    include Cinch::Plugin

    match 'music'
    def execute(m)
      lang = { 'Cookie' => 'lang=it' }
      page = Nokogiri::HTML open('http://musicthoughts.com/t', lang)

      quote  = page.at_xpath('//blockquote//q').text.strip
      author = page.at_xpath('//blockquote//cite').text.strip

      m.reply quote
      m.reply "- #{author}"
    end
  end
end
