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
    match /\.cr (.+)/, :use_prefix => false

    def execute(m)
      series = Crunchyroll::find m.params[1].split('.cr ')[1]
      
      if series
        # m.reply "#{Format(:red, series[:title])} is a series airing on #{Format(:red, series[:where])} at #{Format(:red, series[:day])} #{Format(:red, series[:hour])}:#{Format(:red, series[:min])} which is in #{Format(:red, series[:left])}."
        m.reply "#{Format(:red, series[:title])} è una serie trasmessa da #{Format(:red, series[:where])} il #{Format(:red, series[:day].to_ita)} alle #{Format(:red, series[:hour])}:#{Format(:red, series[:min])}, cioè tra #{Format(:red, series[:left].to_ita)}."
      else
        # m.reply Format(:red, 'Anime not found')
        m.reply Format(:red, 'Anime non trovato')
      end
    end
  end
end
