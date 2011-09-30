desc 'Tunnel to a component in your application'
arg_name 'Component name'
command :tunnel do |c|

  c.desc 'Componant name you want to connect to'
  c.arg_name 'COMPONANT_NAME'
  c.flag [:c, :component]

  c.action do |global_options,options,args|
    Pagoda::Command::Tunnel.new(global_options,options,args).run
  end
end