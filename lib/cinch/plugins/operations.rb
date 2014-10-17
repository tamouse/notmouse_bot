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
        m.reply "#{m.bot.name} in #{m.bot.channels.map(&:name)}" if authorized?(m)
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
        if authorized?(m)
          channels.split.each do |channel|
            yield channel
          end
        end
      end

      def do_command(cmd, m)
        m.bot.__send__(cmd) if authorized?(m)
      end

      def authorized?(m)
        (m.user.oper? || OPERS.include?(m.user.authname)).tap do |t|
          m.target.reply("#{m.user} not authorized") unless t
        end
      end

      def get_channels(msg)
        msg.split[1..-1].tap {|t| debug "DEBUG: channels: #{t.inspect}" }
      end

    end

  end

end
