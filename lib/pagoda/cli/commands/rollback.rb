desc 'Rollback your repo to whatever item it was on last'
command :rollback do

  desc 'Application to be rolled back'
  arg_name 'APP_NAME'
  flag [:a, :app]

  action do |global_options,options,args|
    Pagoda::Command::App.new(global_options,options,args).rollback
  end
end