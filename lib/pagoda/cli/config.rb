require 'gli'
require 'gli/command'
require 'fileutils'
require 'yaml'
require 'pp'
require 'json'

module Pagoda
  module CLI
    class Config < ::GLI::Command # :nodoc:
      COMMANDS_KEY = 'commands'

      def initialize(config_file_name)
        @filename = config_file_name
        super(
          :config,
          "Initialize the config file using current global options",
          nil,
          'Initializes a configuration file where you can set default options for command line flags, both globally and on a per-command basis.  These defaults override the built-in defaults and allow you to omit commonly-used command line flags when invoking this program',
          true
        )

        self.desc 'list all'
        self.switch [:l, :list]
      end

      def execute(global_options,options,arguments)
        if options.dup.delete_if { |k,v| v.blank? }.blank? and arguments.blank?
          GLI.commands[:help].execute(global_options, {}, [ name ])
        else

          pp global_options
          pp options
          pp arguments

          if !File.exist?(@filename)
            FileUtils.mkdir_p(File.dirname(@filename))
          end

          if options[:list]
            raise "config file has not been created yet" if !File.exist?(@filename)

            begin
              data = File.open(@@config_file) { |file| YAML::load(file) }
              puts data.to_yaml
            rescue
              FileUtils.rm_rf(@filename)
              raise "invalid config file"
            end
          else
            begin
              config = File.open(@@config_file) { |file| YAML::load(file) }
            rescue
              FileUtils.rm_rf(@filename)
            ensure
              config ||= {}
            end

            if arguments.length == 2
              config[arguments[0]] = arguments[1]
              File.open(@filename, 'w') do |file|
                YAML.dump(config, file)
              end
            else
              puts config[arguments[0]]
            end
            # config = global_options
            # config[COMMANDS_KEY] = {}
            # GLI.commands.each do |name,command|
            #   if (command != self) && (name != :rdoc) && (name != :help)
            #     config[COMMANDS_KEY][name.to_sym] = {} if command != self
            #   end
            # end
            # File.open(@filename,'w') do |file|
            #   YAML.dump(config,file)
            # end
          end

        end

      end
    end
  end
end