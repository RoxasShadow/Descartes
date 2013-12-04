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
  class RPN
    include Cinch::Plugin

    match /rpn (.+)/, method: :rpn
    def rpn(m)
      query = m.params.split('!rpn ')[1]

      m.reply [].tap { |res|
        query.split.each { |i|
          case i
            when /\d/
              res << i.to_f
            when ?+, ?-, ?*, ?/, ?^
              i = '**' if i == ?^
              res << [].tap { |a|
                a << res.pop while res.last.class == Float
              }.inject(i)
          end
        }
      }.last
    end

    match 'help rpn', method: :help
    def help(m)
      m.reply '!rpn n1 n2 (...) n3 [+|-|*|/|^]'
    end
  end
end
