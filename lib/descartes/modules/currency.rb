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
  class Currency
    include Cinch::Plugin
    match /[0-9]+ [A-Za-z]+ to [A-Za-z]+/, use_prefix: false

    def execute(m)
      amount = m.params[1].match(/[0-9]+/)
      from   = m.params[1].match(/[A-Za-z]+ to/).to_s[0..-4]
      to     = m.params[1].match(/to [A-Za-z]+/).to_s[3..-1]
      
      from = 'jpy' if from == 'yen'
      to   = 'jpy' if to   == 'yen'

      url = "http://www.xe.com/currencyconverter/convert/?Amount=#{amount}&From=#{from}&To=#{to}"
      res = Nokogiri::HTML(open(url)).xpath('//tr[@class="uccRes"]').children[4].text
      m.reply res unless res.strip.empty?
    end
  end
end
