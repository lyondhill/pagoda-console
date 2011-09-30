desc 'You must specify an app name to clone.'
arg_name 'Describe arguments to clone here'
command :clone do

  desc 'The app name for Pagoda Box'
  arg_name 'APP_NAME'
  flag [:a, :app]

  action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).clone
  end
end