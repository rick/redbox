require 'fileutils'

class RakeInstall
  class << self
    def is_installed?(path)
      File.exists?(File.expand_path(File.dirname(__FILE__) + '/../' + path))
    end

    def unpack_tarball(path)
      Dir.chdir(run)
      system("tar xvfz #{vendor}/#{path}")
    end

    def rename_server_path(source, target)
      Dir.chdir(run)
      system("mv #{source} #{target}")
    end

    def vendor
      File.expand_path(File.dirname(__FILE__) + '/../vendor/')
    end

    def run
      File.expand_path(File.dirname(__FILE__) + '/../run/')
    end
  end
end

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
