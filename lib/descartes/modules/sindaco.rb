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
  class Sindaco
    include Cinch::Plugin

    match /Sindaco/

    def execute(m)
      file    = File.expand_path '../reply/sindaco.txt', __FILE__
      replies = [].tap { |ary|
        File.read(file).each_line { |line| ary << line unless line.empty? }
      }
      m.reply replies[rand(1..replies.length)]
    end
  end
end 
