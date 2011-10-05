desc 'Deploy your code to your live pagodabox app'
command :deploy do |c|

  c.desc "Deploy the latest, Without this we will deploy the current branch/commit"
  c.switch [:l, :latest]

  c.desc "commit you would like to deploy to"
  c.arg_name "COMMIT"
  c.flag [:c, :commit]

  c.desc "branch you would like to deploy to"
  c.arg_name "BRANCH"
  c.flag [:b, :branch]

  c.action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).deploy
  end
end