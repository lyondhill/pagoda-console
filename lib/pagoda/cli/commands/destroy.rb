desc 'Destroy your application'
arg_name 'Describe arguments to destroy here'
command :destroy do

  desc "Force without confirmation"
  switch [:f, :force]

  desc 'New app name'
  arg_name 'APP_NAME'
  flag [:a, :app]

  action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).destroy
  end
end