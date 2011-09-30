desc 'Clone an application from pagodabox'
arg_name 'Application Name'
command :clone do |c|

  c.desc 'Your application name on pagodabox'
  c.arg_name 'APP_NAME'
  c.flag [:a, :app]

  c.action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).clone
  end
end