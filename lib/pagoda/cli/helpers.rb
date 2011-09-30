module Pagoda
  module Helpers
    INDENT = "  "
    
    def home_directory
      running_on_windows? ? ENV['USERPROFILE'] : ENV['HOME']
    end

    def running_on_windows?
      RUBY_PLATFORM =~ /mswin32|mingw32/
    end

    def running_on_a_mac?
      RUBY_PLATFORM =~ /-darwin\d/
    end

    def display(msg="", newline=true, level=1)
      indent = build_indent(level)
      if newline
        (running_on_windows?) ? puts("#{indent}#{msg}") : puts("#{indent}#{msg}".green)
      else
        (running_on_windows?) ? print("#{indent}#{msg}") : print("#{indent}#{msg}".green)
        STDOUT.flush
      end
    end
    
    def format_date(date)
      date = Time.parse(date) if date.is_a?(String)
      date.strftime("%Y-%m-%d %H:%M %Z")
    end

    def ask(message=nil, level=1)
      display("#{message}", false, level) if message
      STDIN.gets.strip
    end
    
    def confirm(message="Are you sure you wish to continue? (y/n)?", level=1)
      return true if ARGV.include? "-f"
      case message
      when Array
        count = message.length
        iteration = 0
        message.each do |m|
          if iteration == count - 1
            (running_on_windows?) ? display("#{m} ", false, level) : display("#{m} ".blue, false, level)
          else
            (running_on_windows?) ? display("#{m} ", false, level) : display("#{m} ".blue, true, level)
          end
          iteration += 1
        end
      when String
        (running_on_windows?) ? display("#{message} ", false, level) : display("#{message} ".blue, false, level)
      end
      ask.downcase == 'y'
    end

    def error(msg, exit=true, level=1)
      indent = build_indent(level)
      STDERR.puts
      case msg
      when Array
        (running_on_windows?) ? STDERR.puts("#{indent}** Error:") : STDERR.puts("#{indent}** Error:".red)
        msg.each do |m|
          (running_on_windows?) ? STDERR.puts("#{indent}** #{m}") : STDERR.puts("#{indent}** #{m}".red)
        end
      when String
        (running_on_windows?) ? STDERR.puts("#{indent}** Error: #{msg}") : STDERR.puts("#{indent}** Error: #{msg}".red)
      end
      STDERR.puts
      exit 1 if exit
    end
    
    def has_git?
      %x{ git --version }
      $?.success?
    end

    def git(args)
      return "" unless has_git?
      flattened_args = [args].flatten.compact.join(" ")
      %x{ git #{flattened_args} 2>&1 }.strip
    end

    def create_git_remote(id, remote)
      error "you do not have git installed on your computer" unless has_git?
      error "this remote is already in use on this repo" if git('remote').split("\n").include?(remote)
      unless File.directory?(".git")
        if ask "git has not been initialized yet, would you like us to do this for you? "
          display "git repo is being created in '#{Dir.pwd}'"
          git "init"
        else
          error(["repo has not been initialized." , "try 'git init'"]) 
        end
      end
      git "remote add #{remote} git@pagodabox.com:#{id}.git"
      git "config --add pagoda.id #{id}"
      display "Git remote #{remote} added"
    end

    def build_indent(level=1)
      indent = ""
      level.times do
        indent += INDENT
      end
      indent
    end
    
  end
end

require 'pagoda/cli/helpers/base'
require 'pagoda/cli/helpers/app'
require 'pagoda/cli/helpers/key'
# require 'pagoda/cli/helpers/auth'
require 'pagoda/cli/helpers/help'
require 'pagoda/cli/helpers/tunnel'