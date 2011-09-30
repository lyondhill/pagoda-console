desc 'Deploy your code to your live server'
command :deploy do

  desc "Deploy the latest, Without this we will deploy the current branch/commit"
  switch [:l, :latest]

  action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).deploy
  end
end