# https://github.com/cinchrb/cinch/blob/master/examples/plugins/seen.rb
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