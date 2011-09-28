require 'launchy'

module Pagoda::Command

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
    alias :index :list

    def info
      display
      info = client.app_info(app)
      display "INFO - #{info[:name]}"
      display "//////////////////////////////////"
      display "name       :  #{info[:name]}"
      display "clone_url  :  #{info[:git_url]}"
      display  
      display "owner"
      display "username :  #{info[:owner][:username]}", true, 2
      display "email    :  #{info[:owner][:email]}", true, 2
      display  
      display "collaborators"
      if info[:collaborators].any?
        info[:collaborators].each do |collaborator|
          display "username :  #{collaborator[:username]}", true, 2
          display "email    :  #{collaborator[:email]}", true, 2
        end
      else
        display "(none)", true, 2
      end
      display
    end

    def open
      display "Opening #{app}"
      Launchy.open "http://#{app}.pagodabox.com"
    end

    def rename
      # will be implemented once we have it implemented in the pagoda kernel
      display "not yet implemented"
    end

    # def create
    #   if app_name = app(true)
    #     error ["This project is already launched and paired to #{app_name}.", "To unpair run 'pagoda unpair'"]
    #   end
      
    #   unless locate_app_root
    #     error ["Unable to find git config in this directory or in any parent directory"]
    #   end
      
    #   unless clone_url = extract_git_clone_url
    #     errors = []
    #     errors << "It appears you are using git (fantastic)."
    #     errors << "However we only support git repos hosted with github."
    #     errors << "Please ensure your repo is hosted with github."
    #     error errors
    #   end
      
    #   unless name = args.dup.shift
    #     error "Please Specify an app name ie. 'pagoda launch awesomeapp'"
    #   end
      
    #   display
    #   display "+> Registering #{name}"
    #   client.app_create(name, clone_url)
    #   display "+> Launching...", false
    #   loop_transaction(name)
    #   write_app(name, clone_url)
    #   display "+> #{name} launched"
      
    #   unless option_value(nil, "--latest")
    #     Pagoda::Runner.run_internal("app:deploy", args)
    #   end
      
    #   if option_value(nil, "--with-mysql")
    #     Pagoda::Runner.run_internal("db:create", args)
    #   end
      
    #   display "-----------------------------------------------"
    #   display
    #   display "LIVE URL    : http://#{name}.pagodabox.com"
    #   display "ADMIN PANEL : http://dashboard.pagodabox.com"
    #   display
    #   display "-----------------------------------------------"
    #   display
      
    # end

    def create
      name = args.shift.downcase.strip rescue nil
      remote = option_value("-r", "--remote") || "pagoda"
      if client.app_available?(name)
        id = client.app_create(name)
        display("Creating #{name}...", false)
        loop_transaction
        create_git_remote(id, remote || "pagoda")
      else
        error "App name is already taken"
      end
    end
    alias :launch :create
    alias :register :create

    def deploy
      app
      display
      if option_value(nil, "--latest")
        puts "got options"
        client.app_deploy_latest(app)
        display "+> deploying to latest commit point on github...", false
        loop_transaction
        display "+> deployed"
        display
      else
        client.app_deploy(app, parse_branch, parse_commit)
        display "+> deploying current branch and commit...", false
        loop_transaction
        display "+> deployed"
        display
      end
    end

    def rewind
      app
      display
      transaction = client.app_rewind(app)
      display "+> undo...", false
      loop_transaction
      display "+> done"
      display
    end
    alias :rollback :rewind
    alias :undo :rewind
    
    def fast_forward
      app
      display
      transaction = client.app_fast_forward(app)
      display "+> redo...", false
      loop_transaction
      display "+> done"
      display
    end
    alias :fastforward :fast_forward
    alias :forward :fast_forward
    alias :redo :fast_forward

    def destroy
      display
      if confirm ["Are you totally completely sure you want to delete #{app} forever and ever?", "THIS CANNOT BE UNDONE! (y/n)"]
        display "+> Destroying #{app}"
        client.app_destroy(app)
        display "+> #{app} has been successfully destroyed. RIP #{app}."
        remove_app(app)
      end
      display
    end
    alias :delete :destroy

    def pair
      if app_name = app(true)
        error ["This project is paired to #{app_name}.", "To unpair run 'pagoda unpair'"]
      end
      unless locate_app_root
        error ["Unable to find git config in this directory or in any parent directory"]
      end
      unless my_repo = extract_git_clone_url
        errors = []
        errors << "It appears you are using git (fantastic)."
        errors << "However we only support git repos hosted with github."
        errors << "Please ensure your repo is hosted with github."
        error errors
      end
      
      display
      display "+> Locating deployed app with matching git repo"
      
      apps = client.app_list
      
      matching_apps = []
      apps.each do |a|
        if a[:git_url] == my_repo
          matching_apps.push a
        end
      end
      
      if matching_apps.count > 1
        if name = app(true) || ARGV.first
          assign_app = nil
          matching_apps.each do |a|
            assign_app = a if a[:name] == name
          end
          if assign_app
            display "+> Pairing this repo to deployed app - #{assign_app[:name]}"
            pair_with_remote(assign_app)
            display "+> Repo is now paired to '#{assign_app[:name]}'"
            display
          else
            error "#{name} is not found among your launched app list"
          end
        else
          errors = []
          errors << "Multiple matches found"
          errors << ""
          matching_apps.each do |match|
            errors << "-> #{match[:name]}"
          end
          errors << ""
          errors << "You have more then one app that uses this repo."
          errors << "Please specify which app you would like to pair to."
          errors << ""
          errors << "ex: pagoda pair #{matching_apps[0][:name]}"
          error errors
        end
      elsif matching_apps.count == 1
        match = matching_apps.first
        display "+> Pairing this repo to deployed app - #{match[:name]}"
        pair_with_remote match
        display "+> Repo is now paired to '#{match[:name]}'"
        display
      else
        error "Current git repo doesn't match any launched app repos"
      end
    end
    
    def unpair
      app
      display
      display "+> Unpairing this repo"
      remove_app(app)
      display "+> Free at last!"
      display
    end
  
  protected
    
    def pair_with_remote(app)
      my_app_list = read_apps
      current_root = locate_app_root
      in_list = false
      my_app_list.each do |app_str|
        app_arr = app_str.split(" ")
        if app[:git_url] == app_arr[1] && app[:name] == app_arr[0] || app_arr[2] == current_root
          in_list = true
        end
      end
      unless in_list
        add_app app[:name]
      end
    end


  end
  
end