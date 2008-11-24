require 'fileutils'

here   = File.dirname(__FILE__)
vendor = File.expand_path(here + '/../vendor/')
run    = File.expand_path(here + '/../run/')

desc 'install dependencies'
task :install_dependencies => [ :install_rabbit_mq ] do
  puts "Done."
end

desc 'install the RabbitMQ message server'
task :install_rabbit_mq do
  target = File.expand_path(run+'/rabbitmq') 
  if File.directory?(target)
    puts "RabbitMQ already installed in [#{target}]"
  else
    puts "installing RabbitMQ in [#{target}]..."

    tarball = vendor + '/rabbitmq-server*.tar.gz'
    `cd #{run}; tar xfvz #{tarball}`
    `cd #{run}; mv rabbitmq* rabbitmq`
  end
end
