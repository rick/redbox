require File.expand_path(File.dirname(__FILE__)) + '/rake_install'
require 'rubygems'
require 'mq'

class RabbitMQ
  class << self
    def running?
      ping
    rescue AMQP::Error
      return false
    rescue RuntimeError
      return true
    end

    def ping
      EM.run do
        # This is basically the minimal working set I could derive
        # from the AMQP examples to do a "ping" of the server.
        # Note that we're going to raise an exception either way, and
        # the exceptions ensure that we can exit the eventmachine loop
        # and can use rescue clauses in the caller to see what happened.
        ping = MQ.new.fanout('ping')
        EM.add_periodic_timer(1) { ping.publish('ping'); raise "done" }
        amq = MQ.new
        amq.queue('pong').bind(amq.fanout('ping')).subscribe {|packet| puts packet }
      end
    end
    
    def setup_environment
      server = File.expand_path(File.dirname(__FILE__) + '/../run/')
      ENV['ERLANG_HOME']  = find_erlang_home
      ENV['RABBITMQ_BASE'] = "#{server}/rabbitmq/"
      ENV['MNESIA_BASE']   = "#{server}/mnesia/"
      ENV['LOG_BASE']      = "#{server}/../log/"
    end

    def find_erlang_home
      return ENV['ERLANG_HOME'] if ENV['ERLANG_HOME']

      ENV['PATH'].split(':').each do |path|
        p = File.expand_path(path)
        if File.exists?("#{p}/erl")
          lib = p.sub(%r{/bin(?:|/.*)/?$}, '/lib/erlang')
          return lib if File.exists?(lib)
        end
      end
      ''
    end

    def start
      setup_environment
      Dir.chdir(File.expand_path(File.dirname(__FILE__) + '/../run/rabbitmq/sbin'))
      system("./rabbitmq-server")
    end

    def stop
      setup_environment
      Dir.chdir(File.expand_path(File.dirname(__FILE__) + '/../run/rabbitmq/sbin'))
      system("./rabbitmqctl stop")
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

  desc 'stop the rabbitmq server'
  task :stop do
    raise "RabbitMQ server is not installed -- please run 'rake install_dependencies' first." unless
      RakeInstall.is_installed?('run/rabbitmq')
    RabbitMQ.stop if RabbitMQ.running?
  end
end
