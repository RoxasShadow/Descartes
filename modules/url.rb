#encoding: UTF-8
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
  class Url
    include Cinch::Plugin
    match /http(s)?:\/\/(\S+)/, :use_prefix => false

    def execute(m, ssl, url)
      page = Nokogiri::HTML(open("http#{ssl}://#{url}").read, nil, 'utf-8')

      if url.match('youtube.com|youtu.be') != nil
        m.reply page.css('//title').first.text.chomp(' - YouTube')
      else
        m.reply page.css('//title').first.text.strip
      end
    end
  end
end
