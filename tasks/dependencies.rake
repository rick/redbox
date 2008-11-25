require File.expand_path(File.dirname(__FILE__)) + '/rake_install'

desc 'install dependencies'
task :install_dependencies => [ :install_rabbit_mq ] do
  puts "Done."
end

desc 'install the RabbitMQ message server'
task :install_rabbit_mq do
  target = 'run/rabbitmq'
  if RakeInstall.is_installed?(target)
    puts "RabbitMQ already installed in [#{target}]."
  else
    puts "installing RabbitMQ in [#{target}]..."
    RakeInstall.unpack_tarball('rabbitmq-server*.tar.gz')
    RakeInstall.rename_server_path('rabbitmq_*', 'rabbitmq')
  end
end
