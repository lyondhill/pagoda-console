desc 'Describe deploy here'
arg_name 'Describe arguments to deploy here'
command :deploy do
  action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).deploy
  end
end