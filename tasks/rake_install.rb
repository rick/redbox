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
