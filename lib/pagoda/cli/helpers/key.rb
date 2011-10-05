
module Pagoda
  module Command

    class Key < Base

      def generate_key_and_push
        display 
        display "+> Generating a ssh key pair"
        display 
        if running_on_windows?
          display "It appears you are running on windows"
          display "the best way to generate a key is with an external tool"
          display "We suggest using 'PuTTY'"
        else
          (options[:file] ?  `ssh-keygen -f #{options[:file]}` : `ssh-keygen`)
          display
          push_existing_key
        end
      end

      def push_existing_key
        if file_path = options[:file] || args.first
          unless file_path[0] == '/'
            file_path = Dir.pwd << '/' << file_path
          end
          unless file_path.end_with?(".pub")
            file_path << ".pub"
          end
          if File.exists?(file_path)
            send_key_file(file_path)
          else
            error "file given '#{file_path}' does not exist"
          end
        else
          if File.exists?("#{home_dir}/.ssh/id_rsa.pub") || File.exists?("~/.ssh/id_dsa.pub")
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
          display "+> Pushing ssh key to Pagoda Box"
          display "+> done"
        else
          error "that key is not the correct format"
        end
      rescue RestClient::UnprocessableEntity
        error "It Appears this key is already in use"
      end

    end

  end
end