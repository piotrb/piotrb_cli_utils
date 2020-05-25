# frozen_string_literal: true

module PiotrbCliUtils
  module Util
    def fail_with(*messages, code: 1)
      messages.each do |message|
        warn(Paint[message, :red])
      end
      exit code
    end

    def log(message, depth: 0, newline: true)
      message = Array(message)
      message.each do |m|
        indent = '  ' * depth
        print indent + m
        print "\n" if newline
      end
    end
  end
end
