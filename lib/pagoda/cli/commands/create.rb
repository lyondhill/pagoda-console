desc 'Create a new application on pagodabox'
arg_name 'New application name'
command :create do

  desc 'New app name'
  arg_name 'APP_NAME'
  flag [:a, :app]

  action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).create
  end
end