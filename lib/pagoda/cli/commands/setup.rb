desc "Pagodabox's easy button. Decision tree for initial setup"
command :setup do |c|

  c.action do |global_options,options,args|
    ::Pagoda::Command::App.new(global_options,options,args).setup

  end
end