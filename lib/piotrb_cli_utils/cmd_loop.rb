# frozen_string_literal: true

module PiotrbCliUtils
  module CmdLoop
    # @param prompt [String, Proc] The prompt to use for the command loop.
    #   If a proc is given, it will be called for each time the prompt is
    #   displayed.
    def run_cmd_loop(prompt = '=> ')
      reader = TTY::Reader.new(interrupt: :noop)
      reader.on(:keyctrl_c, :keyescape) do
        return :abort
      end

      reader.on(:keyctrl_d) do
        return :eof
      end

      catch(:stop) do
        loop do
          actual_prompt = prompt.respond_to?(:call) ? prompt.call : prompt
          line = reader.read_line(actual_prompt)
          line.strip!
          yield(line)
        end
      end || :stopped
    end
  end
end
