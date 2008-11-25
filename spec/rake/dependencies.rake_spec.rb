require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'fileutils'
require 'rake'

describe 'rake tasks to setup for automated build' do
  before :each do
    Rake.application = @rake = Rake::Application.new
    load File.expand_path(File.dirname(__FILE__) + '/../../tasks/dependencies.rake')
  end

  after :each do
    Rake.application = nil
  end

  describe 'when checking installation' do
    it 'should allow a path argument' do
      lambda { RakeInstall.is_installed?('foo') }.should_not raise_error(ArgumentError)
    end

    it 'should require a path argument' do
      lambda { RakeInstall.is_installed? }.should raise_error(ArgumentError)
    end
    
    it 'should return true if the named path in our tree exists' do
      RakeInstall.is_installed?(__FILE__).should be_true
    end
    
    it 'should return false if the named path in our tree does not exist' do
      RakeInstall.is_installed?(__FILE__ + '-nonsensical.txt').should be_false
    end

    it 'should identify installed directories' do
      RakeInstall.is_installed?(File.dirname(__FILE__)).should be_true
    end
  end

  describe 'when unpacking a tarball' do
    before :each do
      stub(Dir).chdir(anything)
      stub(RakeInstall).system(anything)
    end
    
    it 'should allow a tarball path argument' do
      lambda { RakeInstall.unpack_tarball('/foo') }.should_not raise_error(ArgumentError)
    end
    
    it 'should require a tarball path argument' do
      lambda { RakeInstall.unpack_tarball }.should raise_error(ArgumentError)
    end

    it 'should unpack the tarball in run/' do
      mock(Dir).chdir(File.expand_path(File.dirname(__FILE__) + '/../../run'))
      RakeInstall.unpack_tarball('foo')
    end
    
    it 'should unpack the named tarball from vendor/ to run/' do
      vendor = File.expand_path(File.dirname(__FILE__) + '/../../vendor')
      mock(RakeInstall).system("tar xvfz #{vendor}/foo")
      RakeInstall.unpack_tarball('foo')
    end
  end

  describe 'when renaming a server directory' do
    before :each do
      stub(Dir).chdir(anything)
      stub(RakeInstall).system(anything)
    end
    
    it 'should allow a path name and a destination name' do
      lambda { RakeInstall.rename_server_path('from', 'to') }.should_not raise_error(ArgumentError)
    end
    
    it 'should require a path name and a destination name' do
      lambda { RakeInstall.rename_server_path('from') }.should raise_error(ArgumentError)
    end
    
    it 'should make the name changes in run/' do
      mock(Dir).chdir(File.expand_path(File.dirname(__FILE__) + '/../../run'))
      RakeInstall.rename_server_path('from', 'to')
    end
    
    it 'should rename the path to the destination name' do
      mock(RakeInstall).system("mv from to")
      RakeInstall.rename_server_path('from', 'to')      
    end
  end

  describe 'when running install_dependencies' do
    it 'should install RabbitMQ' do
      @rake["install_dependencies"].prerequisites.should include("install_rabbit_mq")
    end
  end

  describe 'when running install_rabbit_mq' do
    def run_task
      @rake["install_rabbit_mq"].invoke
    end

    describe 'when rabbitmq is already unpacked' do
      before :each do
        stub(RakeInstall).is_installed?(anything) { true }
      end
      
      it 'should not unpack the rabbitmq tarball from vendor' do
        mock(RakeInstall).unpack_tarball(anything).never
        run_task
      end

      it 'should not rename the rabbitmq install server directory' do
        mock(FileUtils).mv(anything, anything).never
      end
    end

    describe 'when rabbitmq is not already unpacked' do
      before :each do
        stub(RakeInstall).is_installed?(anything) { false }
        stub(RakeInstall).unpack_tarball(anything)
        stub(RakeInstall).rename_server_path(anything, anything)
      end
      
      it 'should unpack the vendored rabbitmq tarball into run/' do
        mock(RakeInstall).unpack_tarball('rabbitmq-server*.tar.gz')
        run_task
      end
      
      it 'should rename the rabbitmq install server directory to rabbitmq' do
        mock(RakeInstall).rename_server_path('rabbitmq_*', 'rabbitmq')
        run_task
      end
    end
  end
end

