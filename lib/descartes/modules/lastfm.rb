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

require 'rockstar'
require 'yaml'

class Descartes
  class LastFm
    include Cinch::Plugin

    #informative 
    match /lastsong/, method: :last_played_song

    #management
    match /lastfmuser add (\w{1,15})/, method: :adduser
    match /lastfmuser remove (\w{1,15})/, method: :removeuser
    match /lastfmuser show ([^\b]+)/, method: :showrelations

    def authenticate()
      Rockstar.lastfm = YAML.load_file(File.join(File.dirname(__FILE__), 'reply', 'lastfm.yml'))
    end

    def lastfm_nicks_archive()
      return YAML.load_file(File.join(File.dirname(__FILE__), 'reply', 'lastfm_nicks.yml'))
    end

    def last_played_song(m)
      usernick = m.user.nick
      authenticate()
      
      lastfmnick=lastfm_nicks_archive()[usernick]
      m.reply "Hey #{usernick}, I don't know your Last.fm nick. add it using !lastfmuser add <lastfmnick>" unless lastfmnick

      user = Rockstar::User.new(lastfmnick)
      track = user.recent_tracks.first

      if track.now_playing?
        if track.album
          m.reply "#{lastfmnick} is listening to #{track.name} by #{track.artist} (in #{track.album}) right now!"
        else
          m.reply "#{lastfmnick} is listening to #{track.name} by #{track.artist} (in no known album) right now!"
        end
      else
        if track.album
          m.reply "the last song #{lastfmnick} listened to is #{track.name} by #{track.artist} (in #{track.album})."
        else
          m.reply "the last song #{lastfmnick} listened to is #{track.name} by #{track.artist} (in no known album)."
        end
      end
    end

    def adduser(m, lastfmnick)
      nicks = lastfm_nicks_archive()
      nicks[m.user.nick] = lastfmnick
      File.open(File.join(File.dirname(__FILE__), 'reply', 'lastfm_nicks.yml'), 'w'){ |f|
          f.write YAML.dump(nicks);
        }
    end

    def removeuser(m, lastfmnick)
      nicks = lastfm_nicks_archive()
      nicks.delete lastfmnick
      File.open(File.join(File.dirname(__FILE__), 'reply', 'lastfm_nicks.yml'), 'w'){ |f|
          f.write YAML.dump(nicks);
        }
    end

    def showrelations(m, usernicks)
      usernick_list = usernicks.split " "
      #read a file N times costs more than read a file just once
      lastfm_nicks_archive().each {|usernick, lastfmnick|
                              m.reply "#{usernick} is known as #{lastfmnick}" if usernick_list.include? usernick
                            }
    end 
  
  end
end
