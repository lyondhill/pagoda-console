desc 'Describe deploy here'
arg_name 'Describe arguments to deploy here'
command :deploy do

  desc "Deploy the latest, Without this we will deploy the current branch/commit"
  switch [:l, :latest]

  action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).deploy
  end
end