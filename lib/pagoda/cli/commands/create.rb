desc 'Describe create here'
arg_name 'Describe arguments to create here'
command :create do

  desc 'The app name for Pagoda Box'
  arg_name 'APP_NAME'
  flag [:a, :app]

  action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).create
  end
end