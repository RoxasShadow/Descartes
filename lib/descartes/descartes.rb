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
  def self.load
    Dir.glob(File.expand_path('../modules/*.rb', __FILE__)).each { |plugin|
      require plugin
    }

    return Descartes.constants.map { |p|
      "Descartes::#{p}".split('::').inject(Object) { |o, c| o.const_get c }
    }
  end
end