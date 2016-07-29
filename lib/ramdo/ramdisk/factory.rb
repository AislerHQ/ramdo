module Ramdo
  module Ramdisk
    class Factory
      def self.get
        if RUBY_PLATFORM =~ /linux_not_implemented_yet/
          LinuxWrapper.new
        elsif RUBY_PLATFORM =~ /darwin/
          DarwinWrapper.new
        else
          raise OSNotSupportedException.new("Could not find Ramdisk wrapper for #{RUBY_PLATFORM}")
        end
      end
    end

  end
end