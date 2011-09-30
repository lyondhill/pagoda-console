desc 'Describe info here'
arg_name 'Describe arguments to info here'
command :info do

  desc 'The app name for Pagoda Box'
  arg_name 'APP_NAME'
  flag [:a, :app]

  action do |global_options,options,args|
    app = ::Pagoda::Command::App.new(global_options,options,args)
    app.info

  end
end