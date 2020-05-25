# frozen_string_literal: true

module PiotrbCliUtils
  module CmdLoop
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
          line = reader.read_line(prompt)
          line.strip!
          yield(line)
        end
      end || :stopped
    end
  end
end
