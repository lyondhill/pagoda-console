desc 'Generate an ssh key and post it to pagodabox'
arg_name 'Describe arguments to destroy here'
command 'key:gen' do

  action do |global_options,options,args|
    Pagoda::Command::Key.new(global_options,options,args).generate_key_and_push
  end
end

desc 'Post an existiong ssh key to pagodabox'
command 'key:push' do

  action do |global_options,options,args|
    Pagoda::Command::Key.new(global_options,options,args).push_existing_key


  end
end