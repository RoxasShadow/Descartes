# encoding: UTF-8
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

require 'crunchyroll'

class Descartes
  class Crunchybot
    include Cinch::Plugin

    match  /\.cr$/, use_prefix: false, method: :today
    def today(m)
      crunchyroll   = Crunchyroll.today
      not_aired     = crunchyroll.reject { |h| h[:aired] }
      already_aired = (crunchyroll - not_aired).map { |r| r[:title].colorize }.flatten.join(', ')[0..-2]

      m.reply "Gli anime di oggi su #{'Crunchyroll'.colorize}:"

      not_aired.each { |series|
        m.reply "#{series[:title].colorize} (tra #{series[:left].to_ita.colorize})"
      }
      
      m.reply "Sono stati già trasmessi: #{already_aired}."
    end

    match  /\.cr (.+)/, use_prefix: false, method: :get
    def get(m)
      series = Crunchyroll.get m.params[1].split('.cr ')[1]
      
      if series
        m.reply "#{series[:title].colorize} è una serie trasmessa da #{series[:where].colorize} il #{series[:day].to_ita.colorize} alle #{series[:hour].colorize}:#{series[:min].colorize}, cioè tra #{series[:left].to_ita.colorize}."
      else
        m.reply 'Anime non trovato'.colorize
      end
    end
  end
end
