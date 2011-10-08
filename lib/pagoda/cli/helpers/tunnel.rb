require 'pagoda-tunnel'

module Pagoda::Command
  class Tunnel < Base

    def run
      component_name = args.first
      component = client.component_info(app, component_name)
      require 'pp'
      pp component
      if component[:tunnelable]
        type = component[:_type]
        component_id = component[:_id]
        app_id = component[:app_id]
        Pagoda::Tunnel.new(type, user, password, app_id, component_id).start
      else
        error "Either the component is not tunnelable or you do not have access"
      end
    # rescue
    #   error "Done Brokedon! Either the component does not exist or it is not tunnelable"
    end

  end
end