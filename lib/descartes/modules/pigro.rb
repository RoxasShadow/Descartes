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
require 'json'

class Descartes
  class Pigro
    include Cinch::Plugin

    match /staff (.+)/, method: :by_staff
    def by_staff(m, user)
      user = user.split
      role = user.last.to_sym.downcase

      if [ :translator, :editor, :checker, :timer, :typesetter, :encoder, :qchecker ].include? role
        user.pop
        options = { user: user.join, role: role }
      else
        options = { user: user.join             }
      end

      host  = get_host
      shows = Assonnato.new(host).show

      series = shows.all(:ongoing, options) + shows.all(:dropped, options) + shows.all(:finished, options)

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

    match /show (.+)/,  method: :by_show
    def by_show(m, keyword)
      s       = keyword.split
      n_ep    = (s.last == 'last' || s.last.numeric?) ? s.pop : nil
      keyword = s.join ' '

      host     = get_host
      shows    = Assonnato.new(host).show
      episodes = Assonnato.new(host).episode

      series = shows.search keyword

      if series.empty?
        m.reply 'Series not found.'
      else
        series.take(5).each { |s|
          show = shows.get(s.name).first

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
          elsif n_ep == 'last'
            episode = episodes.last(:ongoing).select { |ep| ep.show_name == s.name }.last

            if episode
              m.reply ("#{show.name.colorize} ##{episode.episode}".colorize + ' - ').tap { |staff|
                activities = {
                  :Translation => episode.translation,
                  :Editing     => episode.editing,
                  :Check       => episode.checking,
                  :Timing      => episode.timing,
                  :Typesetting => episode.typesetting,
                  :Encoding    => episode.encoding,
                  :QC          => episode.qchecking
                }

                if activities.select { |k, v| v != :done }.any?
                  staff << ''.tap { |s|
                    activities.each_pair { |key, val|
                      s << "#{key.to_s.colorize}: #{val} / "
                    }
                  }[0..-3]
                else
                  staff << 'Already released. '
                end
                staff << "#{'Download'.colorize}: #{episode.download}" unless episode.download.strip.empty?
              }
            else
              m.reply "#{show.name.colorize} has no episodes yet."
            end
          else
            episodes = episodes.get show.name, n_ep.to_i

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

                  if activities.select { |k, v| v != :done }.any?
                    staff << ''.tap { |s|
                      activities.each_pair { |key, val|
                        s << "#{key.to_s.colorize}: #{val} / "
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
    end

    match /pigro (.+)/, method: :edit_episode
    def edit_episode(m, things)
      if not m.user.authed?
        m.reply 'You have to login first.'
        return
      end

      things  = things.split ' '
      len     = things.length

      if things.last.numeric?
        episode = things.pop
        show    = things.join ' '
      elsif len >= 4
        status  = things.pop
        field   = things.pop
        episode = things.pop
        show    = things.join ' '
      else
        m.reply 'usage: !pigro SHOW EPISODE [FIELD] [STATUS]'
        return
      end

      host      = get_host
      user      = get_user m.user.nick
      assonnato = Assonnato.new host

      series = assonnato.show.search show
      if series.length != 1
        m.reply 'You should refine your search.'
        return
      else
        show = series.first.name
      end

      if user
        login = assonnato.user.login user['username'], user['password']
        if login['status'] == 'error'
          m.reply login['message']
        else
          if !field || !status
            [ :translation, :editing, :checking, :timing, :typesetting, :encoding, :qchecking ].each { |f|
              ep = assonnato.episode.edit show, episode.to_i, { f => :done }
              m.reply("#{f}: #{ep['message']}") if ep['status'] != 'success'
            }
            m.reply "The episode has been edited."
          else
            ep = assonnato.episode.edit show, episode.to_i, { field.to_sym => status.to_sym }
            m.reply ep['message']
          end

          assonnato.user.logout
        end
      else
        m.reply 'You are not recognized.'
      end
    end

    def get_user(nickname)
      file = File.join $options[:dotfiles], 'pigro.json'

      if File.exists? file
        users = JSON.parse File.read(file)
        users.select { |user|
          user['nicknames'].select { |n| n['nickname'] == nickname }
        }.last
      else
        false
      end
    end

    def get_host
      file = File.join $options[:dotfiles], 'pigro.txt'

      if File.exists? file
        url = File.read(file).strip
        return url unless url.empty?
      end
      
      'pigro.omnivium.it'
    end
  end
end
