require 'notmouse_bot/showtitle'

module Cinch
  module Plugins
    class Showtitle
      include Cinch::Plugin

      match %r{\bhttps?://}, :use_prefix => false, :use_suffix => false, :strip_colors => true

      def execute(m)
        unless m.user.nick == bot.nick
          urls = Array(URI.extract(m.message))
          urls.each do |u|
            target, title = NotmouseBot::Showtitle.title(u)
            m.reply "title for #{target}: #{title}", false
          end
        end
      end
    end
    
  end
  
end
