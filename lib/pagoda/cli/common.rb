require 'pagoda/cli/config'

module Pagoda
  module CLI
    module Common
      extend self
      include GLI

      def config_file(filename)
        puts "CONFIGFILE = #{filename}"
        if filename =~ /^\//
          @@config_file = filename
        else
          @@config_file = File.join(File.expand_path('~'),filename)
        end
        puts @@config_file
        commands[:config] = Pagoda::CLI::Config.new(@@config_file)
        puts commands[:config]
        @@config_file
      end

      def parse_config # :nodoc:
        return nil if @@config_file.nil?
        require 'yaml'
        if File.exist?(@@config_file)
          File.open(@@config_file) { |file| YAML::load(file) }
        else
          {}
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
  end
end