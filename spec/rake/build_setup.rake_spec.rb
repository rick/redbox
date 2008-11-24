require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'fileutils'
require 'rake'

describe 'rake tasks to setup for automated build' do

  before :each do
    Rake.application = @rake = Rake::Application.new
    load File.expand_path(File.dirname(__FILE__) + '/../../tasks/build_setup.rake')
  end

  after :each do
    Rake.application = nil
  end

  describe 'when running build_setup' do
    before :each do
      stub(FileUtils).copy(anything, anything) { true }
    end

    def run_task
      @rake["build_setup"].invoke
    end

    it 'should copy spec/spec.opts.example to spec/spec.opts' do
      root = File.expand_path(File.dirname(__FILE__ + '/../../../../'))
      mock(FileUtils).copy(File.join(root, 'spec', 'spec.opts.example'),
                           File.join(root, 'spec', 'spec.opts')) { true }
      run_task
    end
  end
end

