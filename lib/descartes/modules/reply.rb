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

		match /(.*)\?/, :use_prefix => @nickname

		def execute(m)
      file    = File.expand_path '../reply/replies.txt', __FILE__
			replies = [].tap { |ary| File.read(file).each_line { |line| ary << line } }
			m.reply replies[rand(1..20)]
		end
	end
end	
