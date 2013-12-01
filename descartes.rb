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

require 'cinch'
require 'cinch/plugins/login'

class Descartes
  def self.load(folder)
    Dir.glob(File.join(folder, '*.rb')).each { |plugin|
      require "./#{plugin}"
    }

    return Descartes.constants.map { |p|
      "Descartes::#{p}".split('::').inject(Object) { |o, c| o.const_get c }
    }
  end
end

server   = ARGV[0]     || 'irc.rizon.net'
channels = ARGV[1..-1] || ['#aggvistnurummor']
plugins  = Descartes.load 'modules'

Cinch::Bot.new {
  configure do |c|
    c.nick     = 'Descartes'
    c.realname = 'Descartes'
    c.user     = 'Descartes'
    c.server   = server
    c.channels = channels
    
    c.plugins.plugins  = [Cinch::Plugins::Login] + plugins
    c.plugins.options[Cinch::Plugins::Login] = { :password => 'dat_password' }
  end

  on :message, 'get' do |m|
    m.reply m.bot.plugins.last
  end

}.start