desc 'Describe list here'
arg_name 'Describe arguments to list here'
command :list do |c|

  c.desc "Web Components"
  c.switch [:w, :web]

  c.action do |global_options,options,args|

    app = ::Pagoda::Command::App.new(args)
    app.list

  end
end