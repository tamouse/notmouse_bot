module Cinch
  module Plugins
    class Operations
      include Cinch::Plugin 

      OPERS = ['tamouse__']

      match /channels/, :method => :show_channels, :prefix => '!!'
      match /part (.+)/, :method => :part_channel, :prefix => '!!'
      match /join (.+)/, :method => :join_channel, :prefix => '!!'
      match /quit/, :method => :quit_irc, :prefix => '!!'

      def show_channels(m)
        if authorized?(m.user)
          m.reply "#{m.bot.name} in #{m.bot.channels.map(&:name)}"
        else
          m.reply "You are not authorized.", true
        end
      end

      def part_channel(m, channels)
        do_channels_command(m, channels) do |channel|
          m.bot.part(channel) if m.bot.channels.map(&:name).include? channel
        end
      end

      def join_channel(m, channels)
        do_channels_command(m, channels) do |channel|
          m.bot.join(channel)
        end
      end

      def quit_irc(m)
        do_command(:quit, m)
      end

      def do_channels_command(m, channels, &block)
        if authorized?(m.user)
          channels.split.each do |channel|
            yield channel
          end
        else
          m.reply "You are not authorized.", true
        end
      end

      def do_command(cmd, m)
        if authorized?(m.user)
          m.bot.__send__(cmd)
        else
          m.reply "You are not authorized.", true
        end
      end

      def authorized?(user)
        user.oper? || OPERS.include?(user.authname)
      end

      def get_channels(msg)
        msg.split[1..-1].tap {|t| debug "DEBUG: channels: #{t.inspect}" }
      end

    end

  end

end
