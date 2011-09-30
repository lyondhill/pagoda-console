desc 'Describe tunnel here'
arg_name 'Describe arguments to tunnel here'
command :tunnel do
  action do |global_options,options,args|
    Pagoda::Command::Tunnel.new(global_options,options,args).run
  end
end