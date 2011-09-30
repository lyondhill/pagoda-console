desc 'Deploy your code to your live server'
command :deploy do |c|

  c.desc "Deploy the latest, Without this we will deploy the current branch/commit"
  c.switch [:l, :latest]

  c.action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).deploy
  end
end