desc 'Describe rollback here'
arg_name 'Describe arguments to rollback here'
command :rollback do
  action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).rewind
  end
end