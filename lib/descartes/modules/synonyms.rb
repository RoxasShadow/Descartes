# encoding: UTF-8
# ##
# ##            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
# ##                    Version 2, December 2004
# ## 
# ## Everyone is permitted to copy and distribute verbatim or modified
# ## copies of this license document, and changing it is allowed as long
# ## as the name is changed.
# ## 
# ##            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
# ##   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
# ## 
# ##  0. You just DO WHAT THE FUCK YOU WANT TO.
# ##
require 'nokogiri'
require 'open-uri'

class Descartes
  class Synonyms
    include Cinch::Plugin
    match /syn (.+)/

    def execute(m, word) # search synonyms of a term in the most famous italian vocabulary
      begin
        url = "http://www.treccani.it/vocabolario/#{word}_(Sinonimi-e-Contrari)/"
        page = Nokogiri::HTML(open(url))
        m.reply page.at_xpath('//div[@class="spiega attacco"]/p').text.strip + " di più qui: #{url}"
      rescue
        m.reply 'Vocabolo non trovato.'
      end
    end
  end
end