require 'utils/logger'
require 'utils/cfg'

module Utils
  class Shell
    class << self
      def execute(cmd)
        return system cmd
      end
    end
  end
end
