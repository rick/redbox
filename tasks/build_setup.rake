require 'fileutils'

desc 'prepare for automated build'
task :build_setup do
  ROOT_PATH = File.expand_path(File.dirname(__FILE__) + '/../')

  FileUtils.copy(File.join(ROOT_PATH, 'spec', 'spec.opts.example'), 
		 File.join(ROOT_PATH, 'spec', 'spec.opts'))
end

