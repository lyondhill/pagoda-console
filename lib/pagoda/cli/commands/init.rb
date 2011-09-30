desc 'Describe init here'
arg_name 'Describe arguments to init here'
command :init do
  action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).init
  end
end