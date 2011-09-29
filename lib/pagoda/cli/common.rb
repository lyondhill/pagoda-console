module Pagoda
  module CLI
    module Common
      extend self
      include GLI

      def command(*names)
        command = Command.new([names].flatten,@@next_desc,@@next_arg_name,@@next_long_desc,@@skips_pre,@@skips_post)
        commands[command.name] = command
        yield command
        command.tap do |c|
          c.desc "Help"
          c.switch [:h, :help]
        end
        clear_nexts
      end

    end
  end
end