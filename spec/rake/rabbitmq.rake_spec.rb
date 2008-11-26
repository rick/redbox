require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'rake'

describe 'rake tasks to control rabbitmq server' do

  before :each do
    Rake.application = @rake = Rake::Application.new
    load File.expand_path(File.dirname(__FILE__) + '/../../tasks/rabbitmq.rake')
  end

  after :each do
    Rake.application = nil
  end

  describe 'determining if rabbitmq is running' do
    it 'should work without arguments' do
      lambda { RabbitMQ.running? }.should_not raise_error(ArgumentError)
    end

    it 'should not allow arguments' do
      lambda { RabbitMQ.running?(:foo) }.should raise_error(ArgumentError)
    end

    it 'should attempt to connect to rabbitmq'

    it 'should return true if rabbitmq is running'

    it 'should return false if rabbitmq is not running'
  end

  describe 'settup up a localized rabbitmq environment' do
    before :each do
      stub(RabbitMQ).find_erlang_home { '/path/to/erlang/home' }
      @server = File.expand_path(File.dirname(__FILE__) + '/../../run/')
      @old_erlang_home, ENV['ERLANG_HOME'] = ENV['ERLANG_HOME'], nil
      @old_rabbitmq_base, ENV['RABBITMQ_BASE'] = ENV['RABBITMQ_BASE'], nil
      @old_mnesia_base, ENV['MNESIA_BASE'] = ENV['MNESIA_BASE'], nil
      @old_log_base, ENV['LOG_BASE'] = ENV['LOG_BASE'], nil      
    end

    after :each do
      ENV['ERLANG_HOME']   = @old_erlang_home
      ENV['RABBITMQ_BASE'] = @old_rabbitmq_base
      ENV['MNESIA_BASE']   = @old_mnesia_base
      ENV['LOG_BASE']      = @old_log_base
    end
    
    it 'should work without arguments' do
      lambda { RabbitMQ.setup_environment }.should_not raise_error(ArgumentError)
    end

    it 'should not allow arguments' do
      lambda { RabbitMQ.setup_environment(:foo) }.should raise_error(ArgumentError)
    end

    it 'should lookup the erlang home path' do
      mock(RabbitMQ).find_erlang_home
      RabbitMQ.setup_environment
    end

    it 'should set the ERLANG_HOME path' do
      RabbitMQ.setup_environment
      ENV['ERLANG_HOME'].should == '/path/to/erlang/home'
    end

    it 'should set the RABBITMQ_BASE path' do
      RabbitMQ.setup_environment
      ENV['RABBITMQ_BASE'].should == "#{@server}/rabbitmq/"
    end

    it 'should set the MNESIA_BASE path' do
      RabbitMQ.setup_environment
      ENV['MNESIA_BASE'].should == "#{@server}/mnesia/"
    end

    it 'should set the LOG_BASE path' do
      RabbitMQ.setup_environment
      ENV['LOG_BASE'].should == "#{@server}/../log/"      
    end
  end
  
  describe 'starting the rabbitmq server' do
    before :each do
      stub(RabbitMQ).system(anything)
      stub(RabbitMQ).setup_environment
      stub(Dir).chdir(anything)
    end
    
    it 'should work without arguments' do
      lambda { RabbitMQ.start }.should_not raise_error(ArgumentError)
    end

    it 'should not allow arguments' do
      lambda { RabbitMQ.start(:foo) }.should raise_error(ArgumentError)
    end

    it 'should configure the environment for localized running of rabbitmq' do
      mock(RabbitMQ).setup_environment
      RabbitMQ.start
    end

    it 'should run the server from the rabbitmq sbin directory' do
      mock(Dir).chdir(File.expand_path(File.dirname(__FILE__) + '/../../run/rabbitmq/sbin/'))
      RabbitMQ.start
    end

    it 'should start the rabbitmq server' do
      mock(RabbitMQ).system("./rabbitmq-server")
      RabbitMQ.start
    end
  end

  describe 'when running rabbitmq:start' do
    def run_task
      @rake["rabbitmq:start"].invoke
    end

    describe 'when rabbitmq server is not installed' do
      before :each do
        stub(RakeInstall).is_installed?(anything)  { false }
      end

      it 'should fail' do
        lambda { run_task }.should raise_error
      end
    end

    describe 'when rabbitmq server is installed' do
      before :each do
        stub(RakeInstall).is_installed?(anything) { true }
      end

      it 'should determine if the rabbitmq server is running' do
        mock(RabbitMQ).running? { true }
        run_task
      end

      describe 'when the rabbitmq server is already running' do
        before :each do
          stub(RabbitMQ).running? { true }
        end

        it 'should not start the rabbitmq server' do
          mock(RabbitMQ).start.never
          run_task
        end
      end

      describe 'when the rabbitmq server is not running' do
        before :each do
          stub(RabbitMQ).running? { false }
        end

        it 'should start the rabbitmq server' do
          mock(RabbitMQ).start
          run_task
        end
      end
    end
  end
end

