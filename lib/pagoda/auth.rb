require 'pagoda/helpers'

module Pagoda
  class Auth
    extend Pagoda::Helpers


    class << self


      # def init
      #   client = Pagoda::Client.new(user, password)
      #   client.on_warning { |message| self.display("\n#{message}\n\n") }
      #   client
      # end

      def validate
        credentials
        # \/ this will go in once the api is in place
        # cli = Pagoda::Client.new(user, password)
        # until cli.valid_credentials? 
        #   delete_credentials
        #   error ["Authentication failed"]
        # end
      end

      def check_for_credentials
        if option_value("-u", "--username") && option_value("-p", "--password")
          [option_value("-u", "--username"), option_value("-p", "--password")]
        else
          false
        end
      end
      
      def user # :nodoc:
        credentials[0]
      end

      def password # :nodoc:
        credentials[1]
      end
      
      def credentials_file
        "#{home_directory}/.pagoda/credentials"
      end

      def credentials # :nodoc:
        unless cred = (check_for_credentials || read_credentials)
          cred = ask_for_credentials
          save_credentials(cred)
        end
        cred
      end

      def read_credentials
        File.exists?(credentials_file) and File.read(credentials_file).split("\n")
      end

      def ask_for_credentials
        unless username = option_value("-u", "--username")
          username = ask "Username: "
        end
        unless password = option_value("-p", "--password")
          display "Password: ", false
          password = running_on_windows? ? ask_for_password_on_windows : ask_for_password
        end
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

      def save_credentials(cred)
        cli = Pagoda::Client.new(cred[0],cred[1])
        begin
          cli.app_list
          write_credentials(cred)
        rescue Exception => e
          puts e.message
          error ["Authentication failed"]
        end
      end

      def retry_login?
        @@login_attempts ||= 0
        @@login_attempts += 1
        @@login_attempts < 3
      end

      def write_credentials(cred)
        FileUtils.mkdir_p(File.dirname(credentials_file))
        File.open(credentials_file, 'w') do |file|
          file.puts cred
        end
        set_credentials_permissions
      end

      def set_credentials_permissions
        FileUtils.chmod 0700, File.dirname(credentials_file)
        FileUtils.chmod 0600, credentials_file
      end

      def delete_credentials
        FileUtils.rm_f(credentials_file)
      end

      def echo_off
        system "stty -echo"
      end

      def echo_on
        system "stty echo"
      end

    end

  end
end