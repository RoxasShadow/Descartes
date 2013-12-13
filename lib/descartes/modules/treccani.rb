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
require 'treccani'

class Descartes
  class Treccani
    include Cinch::Plugin
    set :prefix, '!trec '

    match 'cit',      method: :citazione
    match /enc (.+)/, method: :enciclopedia
    match /syn (.+)/, method: :sinonimi
    match /voc (.+)/, method: :vocabolario

    def citazione(m)
      treccani = Treccani::Citazione.new.get
      m.reply "#{treccani[:citazione]} - #{treccani[:autore]}"
    end

    def enciclopedia(m, word)
      begin
        m.reply Treccani::Enciclopedia.new.get(word)[:meanings].first[0..400]
        m.reply "- #{Treccani::Enciclopedia.new.get_url word}"
      rescue
        m.reply 'Vocabolo non trovato.'
      end
    end

    def sinonimi(m, word)
      begin
        m.reply Treccani::Sinonimi.new.get word
      rescue
        m.reply 'Vocabolo non trovato.'
      end
    end

    def vocabolario(m, word)
      begin
        m.reply Treccani::Vocabolario.new.get(word)[:meanings].first[0..400]
        m.reply "- #{Treccani::Vocabolario.new.get_url word}"
      rescue
        m.reply 'Vocabolo non trovato.'
      end
    end
  end
end
