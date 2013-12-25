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
require 'cgi'

class Descartes
  class Google
    include Cinch::Plugin
    match /google (.+)/

    def search(query)
      page = Nokogiri::HTML open("http://www.google.com/search?q=#{CGI.escape(query)}")

      [].tap { |res|
        page.search('cite').each { |r|
          res << { url: r.inner_text }
        }

        page.xpath('//h3[@class="r"]').each_with_index { |r, i|
          res[i][:title] = r.child.inner_text
        }
      }
    end

    def execute(m, query)
      res = search query

      if res.empty?
        # m.reply 'No results found.'
        m.reply 'Nessun risultato.'
      else
        res[0..3].each { |r| m.reply "#{r[:title]} - #{r[:url]}" }
      end
    end
  end
end