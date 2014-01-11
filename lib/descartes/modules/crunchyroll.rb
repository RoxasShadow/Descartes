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
    match /\.cr (.+)/, use_prefix: false

    def execute(m)
      series = Crunchyroll::find m.params[1].split('.cr ')[1]
      
      if series
        # m.reply "#{series[:title].colorize} is a series airing on #{series[:where].colorize} at #{series[:day].colorize} #{series[:hour].colorize}:#{series[:min].colorize} which is in #{series[:left].colorize}."
        m.reply "#{series[:title].colorize} è una serie trasmessa da #{series[:where].colorize} il #{series[:day].to_ita.colorize} alle #{series[:hour].colorize}:#{series[:min].colorize}, cioè tra #{series[:left].to_ita.colorize}."
      else
        # m.reply 'Anime not found'.colorize
        m.reply 'Anime non trovato'.colorize
      end
    end
  end
end
