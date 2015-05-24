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
	class Reminder
		include Cinch::Plugin
		match /!rem ([0-1]?[0-9]|[2][0-3]):([0-5]?[0-9]) (.+)/, use_prefix: false
		@@active_threads = []

		def execute(m, hour, min, msg)
			time = Time.new(Time.now.year, Time.now.month, Time.now.day, hour, min, 0)
			
			if Time.now < time
				if @@active_threads.size < 10
					@@active_threads << Thread.new { sleep (time - Time.now) ; m.reply "#{m.user.nick}: #{msg}" }
					m.reply 'Will be done'
				else
					m.reply "Stop, please. It's not like I have an elephant memory"
				end	
			else
				m.reply "You can't remind in the past. Not yet."
			end
		end
	end
end
