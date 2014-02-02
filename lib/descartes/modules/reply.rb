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

class Descartes
  class Reply
    include Cinch::Plugin
    
    set :prefix, lambda { |m| Regexp.new "(.*)#{m.bot.nick}(.*)" }
    match ??

    def execute(m)
      file = File.join $options[:dotfiles], 'replies.txt'
      m.reply [].tap { |ary|
        File.read(file).each_line { |line| ary << line unless line.strip.empty? }
      }.sample
    end
  end
end 