require 'pagoda-client'
require 'iniparse'

module Pagoda
  module Command

    class Base
      GIT_REGEX = /^((git@github.com:)|(.*:)|((http|https):\/\/.*github.com\/)|(git:\/\/github.com\/))(.*)\/(.*).git$/i
      include Pagoda::Helpers

      class << self
        include Pagoda::Helpers
        def ask_for_credentials
          username = ask "Username: "
          display "Password: ", false
          password = running_on_windows? ? ask_for_password_on_windows : ask_for_password
          [username, password] # return
        end

        def ask_for_password
          echo_off
          password = ask
          puts
          echo_on
          return password
        end

        def ask_for_password_on_windows
          require "Win32API"
          char = nil
          password = ''
          
          while char = Win32API.new("crtdll", "_getch", [ ], "L").Call do
            break if char == 10 || char == 13 # received carriage return or newline
            if char == 127 || char == 8 # backspace and delete
              password.slice!(-1, 1)
            else
              # windows might throw a -1 at us so make sure to handle RangeError
              (password << char.chr) rescue RangeError
            end
          end
          return password
        end

        def echo_off
          silently(system "stty -echo")
        rescue
        end

        def echo_on
          silently(system "stty echo")
        rescue
        end
          
      end

      
      attr_reader :client
      attr_reader :globals
      attr_reader :options
      attr_accessor :args

      def initialize(globals, options, args)
        @globals = globals
        @options = options
        @args = args
      end

      def user
        globals[:username]
      end

      def password
        globals[:password]
      end

      def client
        @client ||= Pagoda::Client.new(user, password)
      end
      
      def shell(cmd)
        FileUtils.cd(Dir.pwd) {|d| return `#{cmd}`}
      end
      
      def remote
        options[:remote]
      end

      def app(soft_fail=false)
        if app = globals[:app] || options[:app]
          app
        elsif app = extract_app_from_git_config
          app
        elsif app = extract_app_from_remote
          app
        else
          if soft_fail
            false
          else
            raise "Unable to find the app. please specify using -a or --app"
          end
        end
      end
      
      def extract_app_from_git_config
        remote = git("config pagoda.id")
        remote == "" ? nil : remote
      end

      def extract_app_from_remote
        remotes = git_remotes
        if remotes.length == 1
          remotes.values.first
        else
          error "Too many/few apps attached to this repo. please specify --app"
        end
      end

      def git_remotes(base_dir=Dir.pwd)
        remotes = {}
        original_dir = Dir.pwd
        Dir.chdir(base_dir)

        git("remote -v").split("\n").each do |remote|
          name, url, method = remote.split(/\s/)
          if url =~ /^git@pagodabox.com:([\w\d-]+)\.git$/
            remotes[name] = $1
          end
        end
        Dir.chdir(original_dir)
        remotes
      end

      def branch
        options[:branch] || find_branch
      end
      
      def commit
        options[:commit] || find_commit
      end
      
      def find_branch
        git "name-rev --refs=$(git symbolic-ref HEAD) --name-only HEAD"
      end
      
      def find_commit
        git "rev-parse --verify HEAD"
      end
      
      def extract_git_clone_url(soft=false)
        git("config remote.pagoda.url")
      end
      
      def locate_app_root(dir=Dir.pwd)
        return dir if File.exists? "#{dir}/.git/config"
        parent = dir.split('/')[0..-2].join('/')
        return false if parent.empty?
        locate_app_root(parent)
      end

      def loop_transaction(app_name = nil)
        finished = false
        until finished
          display ".", false, 0
          sleep 1
          if client.app_info(app_name || app)[:transactions].count < 1
            finished = true
            display
          end
        end
      end
        
    end
  end
end