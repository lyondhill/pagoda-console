desc 'Rename your application'
command :rename do |c|

  c.desc 'New name to apply to application'
  c.arg_name 'APP_NAME'
  c.flag [:n, :name]

  c.desc 'Old name of application'
  c.arg_name 'APP_NAME'
  c.flag [:o, :old]


  c.action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).rename
  end
end