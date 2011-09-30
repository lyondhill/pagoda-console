module GLI
  class InitConfig < Command # :nodoc:

    def initialize(config_file_name)
      @filename = config_file_name
      super(:config,"Initialize the config file using current global options",nil,'Initializes a configuration file where you can set default options for command line flags, both globally and on a per-command basis.  These defaults override the built-in defaults and allow you to omit commonly-used command line flags when invoking this program')

      self.desc 'force overwrite of existing config file'
      self.switch :force
    end
  end
  def command(*names, &block)
        command = Command.new([names].flatten,@@next_desc,@@next_arg_name,@@next_long_desc,@@skips_pre,@@skips_post)
        commands[command.name] = command
        command.instance_eval(&block)
        # yield command
        command.tap do |c|
          c.desc "Help"
          c.switch [:h, :help]
        end
        clear_nexts
      end

end
