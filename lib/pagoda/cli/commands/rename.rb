desc 'Describe rename here, Haha'
arg_name 'Describe arguments to rename here'
command :rename do
  action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).rename
  end
end