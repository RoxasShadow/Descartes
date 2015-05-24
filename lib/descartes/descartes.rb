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
  class << self
    def load(options = {})
      $options = options
      $options[:exclude] ||= []

      puts 'Importing modules..'
      Dir.glob(File.expand_path('../modules/*.rb', __FILE__)).each do |module|
        name = module.split(?/).last.split(?.).first.downcase

        if $options[:exclude].include?(name)
          puts "- Skipping #{name}..."
        else
          print "- Loading #{name}..."
          require module
          puts ' done'
        end
      end

      return Descartes.constants.map do |p|
        "Descartes::#{p}".split('::').inject(Object) { |o, c| o.const_get c }
      end
    end
  end
end
