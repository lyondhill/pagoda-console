desc 'Rename your application'
arg_name 'Application name'
command :rename do

  desc 'New name to apply to application'
  arg_name 'APP_NAME'
  flag [:n, :name]

  desc 'Old name of application'
  arg_name 'APP_NAME'
  flag [:o, :old]


  action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).rename
  end
end