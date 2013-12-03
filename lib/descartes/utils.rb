class String
  def to_ita
    day_eng = [ 'Sundays',   'Mondays', 'Tuesdays', 'Wednesdays', 'Thursdays', 'Fridays',  'Saturdays' ]
    day_ita = [ 'Domenica',  'Lunedì',  'Martedì',  'Mercoledì',  'Giovedì',   'Venerdì',  'Sabato'    ]
    tim_eng = [ 'days',   'hours', 'minutes', 'seconds' ]
    tim_ita = [ 'giorni', 'ore',   'minuti',  'secondi' ]

    self.tap { |s|
      0.upto(6) { |i| s.gsub! day_eng[i], day_ita[i] }
      0.upto(3) { |i| s.gsub! tim_eng[i], tim_ita[i] }
      s.gsub! 'and', 'e'
    }
  end
end