module Pagoda::Command
  class Help < Base
    def index
      case (args.first.split(":").first rescue "")
      when /app/
        app
      when "auth"
        auth
      when "collaborator", "sharing"
        collaborator
      when "config"
        config
      when "keys"
        keys
      when "logs"
        logs
      when "db", "mysql"
        mysql
      when "tunnel"
        tunnel
      else
        default
      end
    end


    def app
      puts "app"
      case (args.first.split(":").last rescue "")
      when "create"
        display "create"
      when "destroy", "delete"
        display "destroy"
      when "info"
        display "info"
      when "deploy"
        display "deploy"
      when "rewind", "undo"
        display "rewind"
      when "forward", "fastforward", "redo"
        display "forward"
      when "rename"
        display "rename"
      when "pair"
        display "pair"
      when "unpair"
        display "unpair"
      when "open"
        display "open"
      when "list"
        display "list"
      else
        display "app default"
      end
    end

    def auth
      puts "auth"
      case (args.first.split(":").last rescue "")
      when "login", "set"
        display "login"
      when "reset", "logout"
        display "logout"
      when "update"
        display "update"
      else
        display "auth default"
      end
    end

    def collaborator
      puts "collab"
      case (args.first.split(":").last rescue "")
      when "list"
        display "list"
      when "add"
        display "add"
      when "remove"
        display "remove"
      when "transfer"
        display "transfer ownership"
      else
        display "collab default"
      end
    end

    def config
      puts "config"
      case (args.first.split(":").last rescue "")
      when "add"
        display "add"
      when "remove"
        display "remove"
      else
        display "config default"
      end
    end

    def keys
      puts "keys"
      case (args.first.split(":").last rescue "")
      when "add"
        display "add"
      when "list"
        display "list"
      when "remove"
        display "remove"
      when "clear"
        display "clear"
      else
        display "keys default"
      end
    end

    def logs
      puts "logs"
      case (args.first.split(":").last rescue "")
      when "view"
        display "view"
      when "syslog"
        display "syslog"
      else
        display "logs default"
      end
    end

    def mysql
      puts "mysql"
    end

    def tunnel
      puts "tunnel"
    end

    def default
      display %{
Pagoda

NAME
     pagoda -- command line utility for pagodabox.com

SYNOPSIS
     pagoda [command] [parameters]

DESCRIPTION

     If no operands are given, we will attempt to pull data from the current
     directory. If more than one operand is given, non-directory operands are
     displayed first.

     The following options are available:

COMMANDS

    list          # list your apps
    deploy        # Deploy your current state to pagoda
    launch <name> # create (register) a new app
    info          # display info about an app
    destroy       # remove app
    rollback      # rollback app
    tunnel        # create a tunnel to your database on pagoda


PARAMETERS

     ---------------------------
     GLOBAL :
     ---------------------------
     -a <name> | --app=<name>
           Set the application name (Only necessary when not in repo dir).

     -u <username> | --username=<username>
           When set, will not attempt to save your username. Also over-rides
           any saved username.

     -p <password> | --password=<password>
           When set, will not attempt to save your password. Also over-rides
           any saved password.

     -f
           Executes all commands without confirmation request.

     ---------------------------
     DEPLOYING - pagoda deploy :
     ---------------------------
     -b <branch> | --branch=<branch>
           Specify the branch name. By default uses the branch
           your local repo is on.

     -c <commit> | --commit=<commit>
           Specify the commit id. By default uses the commit HEAD is set to.

     --latest
           Will attempt to deploy to the latest commit on github rather than
           your local repo's current commit.

     ---------------------------
     TUNNELING - pagoda tunnel :
     ---------------------------

     -t <type> | --type=<type>
           Specify the tunnel type. (ex:mysql)

     -n <instance> | --name=<instance>
           Specify the instance name you want to operate on used for
           database instance


EXAMPLES
     launch an application on pagoda from inside the clone folder:
     (must be done inside your repo folder)
         pagoda launch <app name>

     list your applications:

         pagoda list

     create tunnel to your database:
     (must be inside your repo folder or specify app)

         pagoda tunnel -a <app name> -t mysql -n <database name>

     destroy an application:
     (must be inside your repo folder or specify app)

         pagoda destroy

        
      }
    end
  end
end