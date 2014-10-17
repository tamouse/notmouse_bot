require 'net/http'
require 'net/https'
require 'open-uri'
require 'nokogiri'

module NotmouseBot
  module Showtitle

    MAX_DEPTH=30

    def self.title(uri)
      return 'no uri' if uri.empty?
      target_uri = resolve_uri(uri)
      doc = Nokogiri::HTML(open(target_uri))
      [target_uri, doc.title]
    rescue RuntimeError => e 
      if e.message =~ /redirection forbidden/
        @retries ||= 0
        @retries += 1
        if @retries < 3
          retry
        else
          raise e
        end
      else
        raise e
      end
    end

    def self.resolve_uri(uri)
      return unless uri
      follow_redirects(uri)
    end

    def self.follow_redirects(uri, depth=0)
      return nil if depth >= MAX_DEPTH
      target = self.fetch_uri(uri)
      case target.code
      when "301", "302", "303", "304"
        follow_redirects(target['location'])
      when "200"
        target.uri.to_s
      else
        nil
      end
    end

    def self.fetch_uri(uri)
      Net::HTTP.get_response(URI(uri))
    end

  end
end
