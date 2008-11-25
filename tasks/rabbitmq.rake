require File.expand_path(File.dirname(__FILE__)) + '/rake_install'

class RabbitMQ
  class << self
    def running?
    end

    def start
    end
  end
end

namespace :rabbitmq do
  desc 'start the rabbitmq server'
  task :start do
    raise "RabbitMQ server is not installed -- please run 'rake install_dependencies' first." unless
      RakeInstall.is_installed?('rabbitmq')
    RabbitMQ.start unless RabbitMQ.running?
  end
end
