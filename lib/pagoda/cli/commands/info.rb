desc 'Get information for a specific app'
arg_name 'Application Name'
command :info do

  desc 'App on pagodabox'
  arg_name 'APP_NAME'
  flag [:a, :app]

  action do |global_options,options,args|
    app = ::Pagoda::Command::App.new(global_options,options,args)
    app.info

  end
end