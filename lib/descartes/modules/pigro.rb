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
    match /dat_show (.+) (.+)/

    def execute(m, keyword, n_ep)
      host     = get_host 'pigro.txt'
      series   = Assonnato::Show.new(host).search! keyword
      episodes = Assonnato::Episode.new host

      if series.empty?
        m.reply 'Series not found'
        return
      end

      series.each { |s|
        m.reply "#{s.name.colorize} (#{s.status} series of #{s.tot_episodes} episodes airing #{s.airing})"
        m.reply ''.tap { |staff|
          {
            :Translator => s.translator,
            :Editor     => s.editor,
            :Checker    => s.checker,
            :Timer      => s.timer,
            :Typesetter => s.typesetter,
            :Encoder    => s.encoder,
            :QC         => s.qchecker
          }.each_pair { |key, val|
            staff << "#{key.to_s.colorize}: #{val} / " unless val.empty?
          }
        }[0..-4]

        eps = episodes.get! s.name, n_ep.to_i
        eps.each { |ep|
          m.reply "Episode #{ep.episode} - ".colorize.tap { |staff|
            {
              :Translation => ep.translation,
              :Editing     => ep.editing,
              :Check       => ep.checking,
              :Timing      => ep.timing,
              :Typesetting => ep.typesetting,
              :Encoding    => ep.encoding,
              :QC          => ep.qchecking
            }.each_pair { |key, val|
              staff << "#{key.to_s.colorize}: #{val ? 'gg' : 'nope'} / "
            }
            staff << 'Download'.colorize + ": #{ep.download}" if ep.download
          }[0..-4]
        }
      }
    end

    def get_host(f)
      file = File.join File.dirname(__FILE__), 'files', f
      File.exists?(file) ? File.read(file) : 'http://localhost'
    end
  end
end
