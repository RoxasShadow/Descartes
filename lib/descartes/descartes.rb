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
    def each_module
      Dir.glob(File.expand_path('../modules/*.rb', __FILE__)).map do |plugin|
        name = File.basename(plugin, '.rb')
        yield plugin, name unless name == 'VERSION'
      end
    end

    def load(options = {})
      $options = options
      $options[:exclude] ||= []

      puts 'Importing modules..'
      each_module do |plugin, name|
        if $options[:exclude].include?(name)
          puts "- Skipping #{name}..."
        else
          print "- Loading #{name}..."
          require plugin
          puts ' done'
        end
      end

      [].tap do |plugins|
        Descartes.constants.map do |name|
          plugin = "Descartes::#{name}".split('::').inject(Object) { |o, c| o.const_get c }
          plugins << plugin if plugin.is_a?(Class) && plugin.include?(Cinch::Plugin)
        end
      end
    end
  end
end
