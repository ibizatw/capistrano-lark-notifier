# frozen_string_literal: true

require_relative "./version"

module Capistrano
  module LarkNotifier
    class Notifier
      def initialize(config = {})
        @webhook_url = config[:webhook]
        raise ArgumentError, "Lark webhook URL is required" unless @webhook_url
      end

      def send_notification(title, content, status = 'info')
        color = case status
                when 'success' then 'green'
                when 'error' then 'red'
                when 'warning' then 'orange'
                else '2F88FF'
                end

        payload = {
          msg_type: "interactive",
          card: {
            config: {
              wide_screen_mode: true
            },
            header: {
              title: {
                tag: "plain_text",
                content: title
              },
              template: color
            },
            elements: [
              {
                tag: "div",
                text: {
                  tag: "lark_md",
                  content: content
                }
              },
              {
                tag: "hr"
              },
              {
                tag: "note",
                elements: [
                  {
                    tag: "plain_text",
                    content: "🕐 #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}"
                  }
                ]
              }
            ]
          }
        }

        send_request(payload)
      end

      private

      def send_request(payload)
        uri = URI.parse(@webhook_url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(uri.request_uri)
        request.content_type = 'application/json'
        request.body = payload.to_json
        response = http.request(request)
        if !response.kind_of?(Net::HTTPSuccess)
          puts "發送 Lark 通知失敗: #{response.code} - #{response.message}"
        end
      end
    
    end
  end
end

