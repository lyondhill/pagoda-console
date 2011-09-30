require 'pagoda-tunnel'

module Pagoda::Command
  class Tunnel < Base

    def run
      puts "in here"
      component_name = args.first
      component = client.app_component_info(app, component_name)
      if component[:tunnelable]
        type = component[:type].to_sym
        component_id = component[:_id]
        Pagoda::Tunnel.new(type, user, password, app, component_id).start
      else
        raise "Security failure"
      end
    rescue
      raise "Unable to run tunneling right now. Try again soon."
    end

    # def mysql
    #   unless instance_name
    #     # try to find mysql instances here
    #     dbs = client.database_list(app)
    #     if dbs.length == 0
    #       errors = []
    #       errors << "It looks like you don't have any MySQL instances for #{app}"
    #       errors << "Feel free to add one in the admin panel (10 MB Free)"
    #       error errors
    #     elsif dbs.length == 1
    #       instance_name = dbs.first[:name]
    #     else
    #       errors = []
    #       errors << "Multiple MySQL instances found"
    #       errors << ""
    #       dbs.each do |instance|
    #         errors << "-> #{instance[:name]}"
    #       end
    #       errors << ""
    #       errors << "Please specify which instance you would like to use."
    #       errors << ""
    #       errors << "ex: pagoda tunnel -n #{dbs[0][:name]}"
    #       error errors
    #     end
    #   end
    #   display
    #   display "+> Authenticating Database Ownership"
      
    #   if client.database_exists?(app, instance_name)
    #     Pagoda::Tunnel.new(:mysql, user, password, app, instance_name).start
    #   else
    #     errors = []
    #     errors << "Security exception -"
    #     errors << "Either the MySQL instance doesn't exist or you are unauthorized"
    #     error errors
    #   end
    # end
  end
end