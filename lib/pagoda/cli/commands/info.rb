desc 'Describe info here'
arg_name 'Describe arguments to info here'
command :info do |c|
  c.action do |global_options,options,args|

    app = ::Pagoda::Command::App.new(%w(-a #{global_options[:app]}))
    app.info

  end
end