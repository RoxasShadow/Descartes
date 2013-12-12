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

class Descartes
  class LastFm
    include Cinch::Plugin

    match /lastsong/

    def lastsong(usernick)
      mah_uber_secret_api_keys={
        api_secret: "secret",
        api_key: "key"
      }
      Rockstar.lastfm=mah_uber_secret_api_keys
      #in the future we'll add reading from file and sh*t
      lastfmnick_archive={
        "alfateam123"  => 'alfateam123',
        "RoxasShadowRS" => 'RoxasShadow'
        };
      
      lastfmnick=lastfmnick_archive[usernick]
      if not lastfmnick
        return "gtfo #{usernick}"
      end

      user = Rockstar::User.new(lastfmnick)
      track = user.recent_tracks.first

      if user.recent_tracks.first.now_playing?
        return "#{lastfmnick} is listening to #{track.name} by #{track.artist} (in #{track.album}) right now!"
      else
        return "the last song #{lastfmnick} listened to is #{track.name} by #{track.artist} (in #{track.album})."
      end
    end

    def execute(m)
      m.reply lastsong(m.user.nick)
    end
  end
end
