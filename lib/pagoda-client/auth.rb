module Pagoda::Auth
  module ClassMethods
    def init
      client = Pagoda::Client.new(user, password)
      client.on_warning { |message| self.display("\n#{message}\n\n") }
      client
    end

    def check_for_credentials
      if option_value("-u", "--username") && option_value("-p", "--password")
        reauthorize
      end
    end
    
    def reauthorize
      @credentials = ask_for_credentials
      write_credentials
    end

    def user # :nodoc:
      get_credentials
      @credentials[0]
    end

    def password # :nodoc:
      get_credentials
      @credentials[1]
    end
    
    def credentials_file
      "#{home_directory}/.pagoda/credentials"
    end

    def get_credentials # :nodoc:
      return if @credentials
      unless @credentials = read_credentials
        @credentials = ask_for_credentials
        save_credentials
      end
      @credentials
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

    def save_credentials
      begin
        write_credentials
        check
      rescue RestClient::Unauthorized => e
        delete_credentials
        raise e unless retry_login?

        error "Authentication failed"
        @credentials = ask_for_credentials
        @client = init_client
        retry
      rescue Exception => e
        delete_credentials
        raise e
      end
    end

    def retry_login?
      @@login_attempts ||= 0
      @@login_attempts += 1
      @@login_attempts < 3
    end

    def write_credentials
      FileUtils.mkdir_p(File.dirname(credentials_file))
      File.open(credentials_file, 'w') do |file|
        file.puts self.credentials
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
  
  module InstanceMethods
    
    def check
      client.app_list
    end

  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end