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

  describe 'starting the rabbitmq server' do
    it 'should work without arguments' do
      lambda { RabbitMQ.start }.should_not raise_error(ArgumentError)
    end

    it 'should not allow arguments' do
      lambda { RabbitMQ.start(:foo) }.should raise_error(ArgumentError)
    end

    it 'should localize the ... setting'
    
    it 'should start the rabbitmq server' do
      
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

