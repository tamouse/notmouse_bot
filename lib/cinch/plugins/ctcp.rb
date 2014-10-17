module Cinch
  module Plugins
    class Ctcp
      include Cinch::Plugin

      ctcp :version

      def ctcp_version(m)
        m.ctcp_reply "NotmouseBot: Version: #{NotmouseBot::VERSION} (Cinch bot version #{Cinch::VERSION})"
      end
      
    end
    
  end
  
end
