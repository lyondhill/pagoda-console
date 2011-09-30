desc 'Describe list here'
arg_name 'Describe arguments to list here'
command :list do

  desc "Web Components"
  switch [:w, :web]

  desc "Database Components"
  switch [:d, :database]

  desc "Cache Components"
  switch [:c, :cache]

  desc "Worker Components"
  switch [:r, :worker]

  action do |global_options,options,args|

    ::Pagoda::Command::App.new(global_options,options,args).list

  end
end