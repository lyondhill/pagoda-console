module Pagoda
  module Command

    class App < Base
      
      def list
        apps = client.app_list
        unless apps.empty?
          display
          display "APPS"
          display "//////////////////////////////////"
          display
          apps.each do |app|
            display "- #{app[:name]}"
          end
        else
          error ["looks like you haven't launched any apps", "type 'pagoda launch' to launch this project"]
        end
        display
      end

      def info
        display
        info = client.app_info(app)
        display "INFO - #{info[:name]}"
        display "//////////////////////////////////"
        display "name       :  #{info[:name]}"
        display "clone_url  :  #{info[:git_url]}"
        display "State      :  #{info[:state]}"
        display
      end

      def rename
        # will be implemented once we have it implemented in the pagoda kernel
        new_name = options[:name] || args.first
        error "I need the new name" unless new_name
        puts client.app_update(app, {:name => new_name})
        display "Successfully changed name to #{new_name}"
      # rescue
      #   error "Given name was either invalid or already in use"
      end

      def init
        id = client.app_info(app)[:_id]
        create_git_remote(id, remote)
      end

      def clone
        error "I need the app you would like to clone" unless app
        id = client.app_info(app)[:_id]
        git "clone git@pagodabox.com:#{id}.git #{app}"
        Dir.chdir(app)
        git "config --add pagoda.id #{id}"
        Dir.chdir("..")
        display "repo has been added"
      end

      def create
        name = args.shift.downcase.strip rescue nil
        if client.app_available?(name)
          puts "available"
          id = client.app_create(name)[:_id]
          puts id
          puts remote
          puts "client called app_create"
          display("Creating #{name}...", false)
          loop_transaction
          create_git_remote(id, remote)
        else
          error "App name is already taken"
        end
      end

      def deploy
        display
        if options[:latest]
          client.app_deploy_latest(app)
          display "+> deploying to latest commit point on github...", false
          loop_transaction
          display "+> deployed"
          display
        else
          client.app_deploy(app, branch, commit)
          display "+> deploying current branch and commit...", false
          loop_transaction
          display "+> deployed"
          display
        end
      end

      def rollback
        app
        display
        transaction = client.app_rollback(app)
        display "+> undo...", false
        loop_transaction
        display "+> done"
        display
      end
      
      # def fast_forward
      #   app
      #   display
      #   transaction = client.app_fast_forward(app)
      #   display "+> redo...", false
      #   loop_transaction
      #   display "+> done"
      #   display
      # end
      # alias :fastforward :fast_forward
      # alias :forward :fast_forward
      # alias :redo :fast_forward

      def destroy
        display
        if options[:force]
          display "+> Destroying #{app}"
          client.app_destroy(app)
          display "+> #{app} has been successfully destroyed. RIP #{app}."
          remove_app(app)
        else
          if confirm ["Are you totally completely sure you want to delete #{app} forever and ever?", "THIS CANNOT BE UNDONE! (y/n)"]
            display "+> Destroying #{app}"
            client.app_destroy(app)
            display "+> #{app} has been successfully destroyed. RIP #{app}."
            remove_app(app)
          end
        end
        display
      end

    end
  end  
end