desc 'Describe info here'
arg_name 'Describe arguments to info here'
command :info do
  action do |global_options,options,args|

    app = ::Pagoda::Command::App.new(global_options,options,args)
    app.info

  end
end