module Pagoda
  module Command

    class App < Base

      # helpful stuff
      def setup
        display "Welcome to Pagodabox"
        display " -- thank you for useing our easy button"
        display "at this point you should have already created an account on pagodabox.com"
        if confirm("Would you like to launch your first app (y/n)? ")
          display "Great!"
          if confirm("have you navigated to the folder of the app you would like to launch in pagodabox (y/n)?")
            display "GReat!"
            error [
              "you do not have git installed on your computer",
              "Pagodabox uses git.",
              "please install git before and then 'pagoda create <app_name>'"
            ] unless has_git?
            options[:app] = ask("what would you like to call your app? ")
            create
          else
            file_path = ask("what folder would you like to launch on pagodabox? ")
            unless file_path[0] == '/'
              file_path = "#{Dir.pwd}/#{file_path}"
            end
            Dir.chdir(file_path)
            error [
              "you do not have git installed on your computer",
              "Pagodabox uses git.",
              "please install git before and then 'pagoda create <app_name>'"
            ] unless has_git?
            options[:app] = ask("what would you like to call your app? ")
            create
            
          end
        else
          display "sorry to hear that."
          display "when you are ready navigate to the repo folder and do a pagoda create <app_name>"
        end

      end

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
          error ["looks like you haven't launched any apps", "type 'pagoda create' to creat this project on pagodabox"]
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
        old_name = options[:old] || app
        new_name = options[:name] || args.first
        error "I need the new name" unless new_name
        error "New name and existiong name cannot be the same" if new_name == old_name
        client.app_update(old_name, {:name => new_name})
        display "Successfully changed name to #{new_name}"
      rescue
        error "Given name was either invalid or already in use"
      end

      def init
        id = client.app_info(app)[:_id]
        create_git_remote(id, remote)
      end

      def clone
        id = client.app_info(app)[:_id]
        git "clone git@pagodabox.com:#{id}.git #{app}"
        Dir.chdir(app)
        git "config --add pagoda.id #{id}"
        Dir.chdir("..")
        display "repo has been added"
      rescue
        error "We were not able to access that app"
      end

      def create
        name = app
        if client.app_available?(name)
          id = client.app_create(name)[:_id]
          display("Creating #{name}...", false)
          loop_transaction
          create_git_remote(id, remote)
        else
          error "App name (#{name}) is already taken"
        end
      end

      def deploy
        display
        if options[:branch] or options[:commit]
          client.app_deploy(app, branch, commit)
          display "+> deploying current branch and commit...", false
          loop_transaction
          display "+> deployed"
          display
        else
          client.app_deploy_latest(app)
          display "+> deploying to latest commit point on pagodabox...", false
          loop_transaction
          display "+> deployed"
          display
        end
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