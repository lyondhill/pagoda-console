desc 'Destroy your application'
arg_name 'Describe arguments to destroy here'
command :destroy do |c|

  c.desc "Force without confirmation"
  c.switch [:f, :force]

  c.desc 'New app name'
  c.arg_name 'APP_NAME'
  c.flag [:a, :app]

  c.action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).destroy
  end
end