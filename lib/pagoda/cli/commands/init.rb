desc 'Initialize your computer with of your pagodabox repo.'
arg_name 'Application to pair with'
command :init do

  desc 'App name initializing to'
  arg_name 'APP_NAME'
  flag [:a, :app]

  action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).init
  end
end