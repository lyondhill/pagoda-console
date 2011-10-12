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
          error ["looks like you haven't launched any apps", "type 'pagoda create' to create this project on pagodabox"]
        end
        display
      end

      def info
        display
        info = client.app_info(app)
        display "INFO - #{info[:name]}"
        display "//////////////////////////////////"
        display "name        :  #{info[:name]}"
        display "clone url   :  git@pagodabox.com:#{info[:id]}.git"
        display
        display "owner"
        display "   username :  #{info[:owner][:username]}"
        display "   email    :  #{info[:owner][:email]}"
        display
        display "collaborators"
        info[:collaborators].each do |collab|
        display "   username :  #{collab[:username]}"
        display "   email    :  #{collab[:email]}"
        end
        display
        display "ssh_portal  :  #{info[:ssh] ? 'enabled' : 'disabled'}"
        display
      end

      def rename
        old_name = options[:old] || app
        new_name = options[:new] || args.first
        error "I need the new name" unless new_name
        error "New name and existiong name cannot be the same" if new_name == old_name
        client.app_update(old_name, {:name => new_name})
        display "Successfully changed name to #{new_name}"
      rescue
        error "Given name was either invalid or already in use"
      end

      def init
        id = client.app_info(app)[:id]
        create_git_remote(id, remote)
      end

      def clone
        app = args.first || app
        id = client.app_info(app)[:id]
        display
        git "clone git@git.pagodabox.com:#{id}.git #{app}"
        Dir.chdir(app)
        git "config --add pagoda.id #{id}"
        Dir.chdir("..")
        display
        display "+> Repo has been added. Navigate to folder #{app}."
      rescue
        error "We were not able to access that app"
      end

      def create
        name = app
        if client.app_available?(name)
          id = client.app_create(name)[:id]
          display("Creating #{name}...", false)
          loop_transaction
          create_git_remote(id, remote)
          display "#{name} created"
          display "----------------------------------------------------"
          display
          display "LIVE URL    : http://#{name}.newpagodabox.com"
          display "ADMIN PANEL : http://dashboard.newpagodabox.com/apps/#{name}"
          display
          display "----------------------------------------------------"
          display
          display "+> Use 'git push #{remote}' to push your code live"
        else
          error "App name (#{name}) is already taken"
        end
      end

      def deploy
        display
        client.app_deploy(app, branch, commit)
        display "+> deploying current branch and commit...", false
        loop_transaction
        display "+> deployed"
        display
      end

      def rollback
        display
        client.app_rollback(app)
        display "+> undo...", false
        loop_transaction
        display "+> done"
        display
      end

      def destroy
        display
        if options[:force]
          display "+> Destroying #{app}"
          client.app_destroy(app)
          display "+> #{app} has been successfully destroyed. RIP #{app}."
          remove_app(app)
        else
          if confirm ["Are you totally completely sure you want to delete #{app} forever and ever?", "THIS CANNOT BE UNDONE! (y/n)"]
            display
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