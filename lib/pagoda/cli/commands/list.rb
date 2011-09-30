desc 'List information on pagodabox'
command :list do |c|

  c.desc "Web Components"
  c.switch [:w, :web]

  c.desc "Database Components"
  c.switch [:d, :database]

  c.desc "Cache Components"
  c.switch [:c, :cache]

  c.desc "Worker Components"
  c.switch [:r, :worker]

  c.action do |global_options,options,args|

    ::Pagoda::Command::App.new(global_options,options,args).list

  end
end