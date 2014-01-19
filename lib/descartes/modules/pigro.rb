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
    match /staff (.+)/, method: :by_staff

    def by_staff(m, user)
      user = user.split(' ')
      role = user.last.to_sym.downcase

      if [ :translator, :editor, :checker, :timer, :typesetter, :encoder, :qchecker ].include? role
        user.pop
        options = { user: user.join(' '), role: role }
      else
        options = { user: user.join(' ')             }
      end

      host  = get_host 'pigro.txt'
      shows = Assonnato::Show.new host

      series = shows.all!(:ongoing, options) + shows.all!(:dropped, options) + shows.all!(:finished, options)

      if series.empty?
        if options.has_key? :role
          m.reply "#{options[:user].colorize} hasn't worked to any series as #{options[:role].colorize}."
        else
          m.reply "#{options[:user].colorize} hasn't worked to any series."
        end
        return
      end

      m.reply ''.tap { |str|
        if options.has_key? :role
          str << "#{series.first.send(options[:role]).colorize} has worked as #{options[:role].colorize} on "
        else
          str << "#{options[:user].colorize} has worked on "
        end

        series.each { |s|
          str << "#{s.name.colorize}, "
        }
      }[0..-3]
    end

    def execute(m, keyword)
      s       = keyword.split ' '
      n_ep    = s.last.numeric? ? s.pop : nil
      keyword = s.join ' '

      host     = get_host 'pigro.txt'
      shows    = Assonnato::Show.new    host
      episodes = Assonnato::Episode.new host

      series = shows.search! keyword

      if series.empty?
        m.reply 'Series not found'
        return
      end

      series.take(5).each { |s|
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
          episodes = episodes.get! show.name, n_ep.to_i

          if episodes.any?
            episodes.each { |ep|
              m.reply ("#{show.name.colorize} ##{ep.episode}".colorize + ' - ').tap { |staff|
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
                else
                  staff << 'Already released. '
                end
                staff << "#{'Download'.colorize}: #{ep.download}" unless ep.download.strip.empty?
              }
            }
          elsif n_ep.to_i > show.tot_episodes
            m.reply "#{m.user.nick.colorize} pls go and http://just-believe.in."
          else
            m.reply "The episode #{n_ep.colorize} has not been added yet to #{show.name.colorize}."
          end
        end
      }
    end

    def get_host(f)
      file = File.join $options[:dotfiles], f

      if File.exists? file
        url = File.read(file).strip
        return url unless url.empty?
      end       
      
      'http://pigro.omnivium.it'
    end
  end
end
