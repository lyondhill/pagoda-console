desc 'Describe create here'
arg_name 'Describe arguments to create here'
command :create do
  action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).create
  end
end