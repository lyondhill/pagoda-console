require 'pagoda-tunnel'

module Pagoda::Command
  class Tunnel < Base

    def run
      component_name = args.first
      component = client.app_component_info(app, component_name)
      if component[:tunnelable]
        type = component[:type].to_sym
        component_id = component[:_id]
        Pagoda::Tunnel.new(type, user, password, app, component_id).start
      else
        error "Either the component is not tunnelable or you do not have access"
      end
    rescue
      error "Unable to access tunnel."
    end

  end
end