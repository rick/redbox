require File.expand_path(File.dirname(__FILE__)) + '/rake_install'

class RabbitMQ
  class << self
    def running?
    end

    def setup_environment
      server = File.expand_path(File.dirname(__FILE__) + '/../run/')
      ENV['ERLANG_HOME']  = find_erlang_home
      ENV['RABBITMQ_BASE'] = "#{server}/rabbitmq/"
      ENV['MNESIA_BASE']   = "#{server}/mnesia/"
      ENV['LOG_BASE']      = "#{server}/../log/"
    end

    def start
      setup_environment
      Dir.chdir(File.expand_path(File.dirname(__FILE__) + '/../run/rabbitmq/sbin'))
      system("./rabbitmq-server")
    end
  end
end

namespace :rabbitmq do
  desc 'start the rabbitmq server'
  task :start do
    raise "RabbitMQ server is not installed -- please run 'rake install_dependencies' first." unless
      RakeInstall.is_installed?('run/rabbitmq')
    RabbitMQ.start unless RabbitMQ.running?
  end
end
