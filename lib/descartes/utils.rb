# encoding: UTF-8
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

class String
  def to_ita
    day_eng = [ 'Sunday',   'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday',  'Saturday' ]
    day_ita = [ 'Domenica', 'Lunedì', 'Martedì', 'Mercoledì', 'Giovedì',  'Venerdì', 'Sabato'   ]
    tim_eng = [ 'days',   'hours', 'minutes', 'seconds' ]
    tim_ita = [ 'giorni', 'ore',   'minuti',  'secondi' ]

    self.tap { |s|
      0.upto(6) { |i| s.gsub! day_eng[i], day_ita[i] }
      0.upto(3) { |i| s.gsub! tim_eng[i], tim_ita[i] }
      s.gsub! 'and', 'e'
    }
  end

  def nl2(wat)
    self.gsub(/\r\n?/, wat)
  end
  
  def decode
    require 'htmlentities'
    HTMLEntities.new.decode self
  end

  def numeric?
    self.to_i.to_s == self || self.to_f.to_s == self
  end
end
