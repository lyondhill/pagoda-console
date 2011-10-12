desc 'Deploy your code to your live pagodabox app'
command :deploy do |c|

  c.desc 'Your application name on pagodabox'
  c.arg_name 'APP_NAME'
  c.flag [:a, :app]

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