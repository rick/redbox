require 'fileutils'

desc 'prepare for automated build'
task :build_setup do
  root = File.expand_path(File.dirname(__FILE__) + '/../')

  FileUtils.copy(File.join(root, 'spec', 'spec.opts.example'), 
		 File.join(root, 'spec', 'spec.opts'))
end

