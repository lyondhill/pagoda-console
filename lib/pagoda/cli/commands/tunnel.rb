desc 'Tunnel to a component in your application'
arg_name 'Component name'
command :tunnel do

  desc 'Componant name you want to connect to'
  arg_name 'COMPONANT_NAME'
  flag [:c, :component]

  action do |global_options,options,args|
    Pagoda::Command::Tunnel.new(global_options,options,args).run
  end
end