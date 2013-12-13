# encoding: UTF-8
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
##
require 'nokogiri'
require 'open-uri'

class Descartes
  class Treccani
    include Cinch::Plugin
    match /trec (.+)/

    def execute(m, word) # search the meaning of a term in the most famous italian vocabulary
      url  = "http://www.treccani.it/vocabolario/tag/#{word}"
      page = Nokogiri::HTML(open(url))
      unless page.at_xpath('//div[@class="intro"]').text.include? 'prodotto alcun risultato'
        m.reply page.at_xpath('//li[@class="result fs"]/p').text.strip + " di più qui: #{url}"  
      else
        m.reply 'Vocabolo non trovato.'
      end
    end
  end
end
