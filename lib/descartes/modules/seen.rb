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

class Descartes
  class Seen
    include Cinch::Plugin

    class SeenStruct < Struct.new(:who, :where, :what, :time)
      def to_s
        "[#{time.asctime}] #{who} was seen in #{where} saying #{what}"
      end
    end

    listen_to :channel
    match /seen (.+)/

    def initialize(*args)
      super
      @users = {}
    end

    def listen(m)
      @users[m.user.nick] = SeenStruct.new(m.user, m.channel, m.message, Time.now)
    end

    def execute(m, nick)
      if nick == @bot.nick
        m.reply "That's me!"
      elsif nick == m.user.nick
        m.reply "That's you!"
      elsif @users.key?(nick)
        m.reply @users[nick].to_s
      else
        m.reply "I haven't seen #{nick}"
      end
    end
  end
end