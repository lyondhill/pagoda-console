desc 'Describe destroy here'
arg_name 'Describe arguments to destroy here'
command :destroy do

  desc "Force without confirmation"
  switch [:f, :force]

  action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).destroy
  end
end