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

require 'assonnato'

class Descartes
  class Pigro
    include Cinch::Plugin
    match /show (.+)/

    def execute(m, keyword)
      s       = keyword.split
      n_ep    = s.last.numeric? ? s.pop : nil
      keyword = s.join

      host     = get_host 'pigro.txt'
      shows    = Assonnato::Show.new    host
      episodes = Assonnato::Episode.new host

      series = shows.search! keyword

      if series.empty?
        m.reply 'Series not found'
        return
      end

      series.each { |s|
        show = shows.get!(s.name).first

        if n_ep.nil?
          a = show.status.downcase.start_with?(?o) ?  'an' : ?a
          m.reply "[#{show.fansub.colorize}] #{show.name.colorize} is #{a} #{show.status} series of #{show.tot_episodes.colorize} episodes."
          m.reply ''.tap { |staff|
            {
              :Translator => show.translator,
              :Editor     => show.editor,
              :Checker    => show.checker,
              :Timer      => show.timer,
              :Typesetter => show.typesetter,
              :Encoder    => show.encoder,
              :QC         => show.qchecker
            }.each_pair { |key, val|
              staff << "#{key.to_s.colorize}: #{val} / " unless val.empty?
            }
          }[0..-4]
        else
          eps = episodes.get! show.name, n_ep.to_i
          eps.each { |ep|
            m.reply ("Episode #{ep.episode}".colorize + ' - ').tap { |staff|
              activities = {
                :Translation => ep.translation,
                :Editing     => ep.editing,
                :Check       => ep.checking,
                :Timing      => ep.timing,
                :Typesetting => ep.typesetting,
                :Encoding    => ep.encoding,
                :QC          => ep.qchecking
              }

              if activities.select { |k, v| !v }.any?
                staff << ''.tap { |s|
                  activities.each_pair { |key, val|
                    s << "#{key.to_s.colorize}: #{val ? 'gg' : 'nope'} / "
                  }
                }[0..-3]
              end
              staff << "#{'Download'.colorize}: #{ep.download}" unless ep.download.strip.empty?
            }
          }
        end
      }
    end

    def get_host(f)
      file = File.join $options[:dotfiles], f

      if File.exists? file
        url = File.read(file).strip
        return url unless url.empty?
      end       
      
      'http://pigro.omnivium.it:4567'
    end
  end
end
