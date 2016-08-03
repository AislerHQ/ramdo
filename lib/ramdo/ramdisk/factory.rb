module Ramdo
  module Ramdisk
    class Factory
      def self.get
        if RUBY_PLATFORM =~ /linux/
          LinuxWrapper.new
        elsif RUBY_PLATFORM =~ /darwin/
          DarwinWrapper.new
        else
          GenericWrapper.new
        end
      end
    end

  end
end
