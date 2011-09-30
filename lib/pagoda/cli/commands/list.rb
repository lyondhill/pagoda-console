desc 'Describe list here'
arg_name 'Describe arguments to list here'
command :list do

  desc "Web Components"
  switch [:w, :web]

  action do |global_options,options,args|

    app = ::Pagoda::Command::App.new(global_options,options,args)
    app.list

  end
end