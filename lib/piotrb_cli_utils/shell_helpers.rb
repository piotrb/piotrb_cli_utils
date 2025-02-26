# frozen_string_literal: true
require "ostruct"

module PiotrbCliUtils
  module ShellHelpers
    def join_cmd(args)
      if args.is_a? Array
        Shellwords.join(args)
      else
        args
      end
    end

    def run_shell(command, return_status: false, echo_command: true, quiet: false, indent: 0)
      command = join_cmd(command)
      puts "#{' ' * indent}$> #{command}" if echo_command
      command += ' 1>/dev/null 2>/dev/null' if quiet
      system command.to_s
      code = $CHILD_STATUS.exitstatus
      raise("failed with code: #{code}") if !return_status && code > 0

      code
    end

    def run_with_each_line(command)
      command = join_cmd(command)
      Open3.popen2e(command) do |_stdin, stdout_and_stderr, wait_thr|
        pid = wait_thr.pid # pid of the started process.
        until stdout_and_stderr.eof?
          raw_line = stdout_and_stderr.gets
          yield(raw_line)
        end
        wait_thr.value # Process::Status object returned.
      end
    end

    def capture_shell(command, error: true, echo_command: true, indent: 0, raise_on_error: false, detailed_result: false)
      command = join_cmd(command)
      puts "#{' ' * indent}<< #{command}" if echo_command
      command += ' 2>/dev/null' unless error
      value = `#{command}`
      code = $CHILD_STATUS.exitstatus
      if raise_on_error && code > 0
        raise("capture_shell: #{command.inspect} failed with code: #{code}")
      end

      if detailed_result
        OpenStruct.new({
                         status: code,
                         output: value
                       })
      else
        value
      end
    end
  end
end
