desc 'Clone an application from pagodabox'
arg_name 'Application Name'
command :clone do

  desc 'Your application name on pagodabox'
  arg_name 'APP_NAME'
  flag [:a, :app]

  action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).clone
  end
end