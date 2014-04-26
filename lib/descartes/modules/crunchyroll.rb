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

    match  /^\.cr$/, use_prefix: false, method: :today
    def today(m)
      crunchyroll   = Crunchyroll.today

      aired    = crunchyroll.select { |h| h[:airs] == :aired    }.map { |r| r[:title].colorize }.flatten.join(', ')[0..-2]
      tomorrow = crunchyroll.select { |h| h[:airs] == :tomorrow }
      today    = crunchyroll.select { |h| h[:airs] == :today    }

      m.reply "Gli anime di oggi su #{'Crunchyroll'.colorize}:"

      today.each { |series|
        m.reply "#{series[:title].colorize} (tra #{series[:left].to_ita.colorize})"
      }

      m.reply '' if today.any?

      if tomorrow.any?
        m.reply "Domani trasmetterà (per via del fuso):"
        tomorrow.each { |series|
          m.reply "#{series[:title].colorize} (tra #{series[:left].to_ita.colorize})"
        }
      end

      m.reply '' if tomorrow.any?
      
      m.reply "Sono stati già trasmessi: #{aired}." unless aired.empty?
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
