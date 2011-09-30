
module Pagoda
  module Command

    class Key < Base

      def generate_key_and_push
        display "+> Generating a ssh key pair"
        if running_on_windows?
          display "It appears you are running on windows"
          display "the best way to generate a key is with an external tool"
          display "We suggest using 'PuTTY'"
        else
          `ssh-keygen`
          push_existing_key
        end
      end

      def push_existing_key
        if running_on_windows?
          get_key_windows
        else
          get_key
        end
      end


      def get_key
        if file_path = options[:file] || args.first
          if File.exists?(file_path)
            send_key_file(file_path)
          else
            error "file given '#{file_path}' does not exist"
          end
        else
          if File.exists?("#{home_dir}/.ssh/id_rsa.pub") || File.exists?("~/.ssh/id_dsa.pub")
            display "+> getting your public key"
            if File.exists?("#{home_dir}/.ssh/id_rsa.pub")
              send_key_file("#{home_dir}/.ssh/id_rsa.pub")
            end

            if File.exists?("#{home_dir}/.ssh/id_dsa.pub")
              send_key_file("#{home_dir}/.ssh/id_dsa.pub")
            end
          else
            display "It appears you do not have a public key."
            display "One should be generated with either id-rsa.pub or id-rsa.pub"
            display "in the #{home_dir}/.ssh folder."
            display "Or you could specify the file 'pagoda key:get ~/.ssh/my_awesome_key.pub"
          end
        end
      end

      def send_key_file(file)
        key = File.read(file).strip
        if key =~ /^ssh-(?:dss|rsa) [A-Za-z0-9+\/]+/
          client.user_add_key(key)
          display "registered key:"
          display key
        else
          error "that key is not the correct format"
        end

      end

    end

  end
end