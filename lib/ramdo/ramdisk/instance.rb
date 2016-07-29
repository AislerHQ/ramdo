module Ramdo
  module Ramdisk
    class Instance
      def self.generate_name
        "ramdo_#{SecureRandom.uuid}"
      end

      attr_accessor :device, :path, :size

      def initialize(info = {})
        @device = info[:device]
        @path = info[:path]
        @size = info[:size]
      end

      def destroy!
        return false unless File.exist? @device

        line = Cocaine::CommandLine.new("hdiutil", "detach :device")
        line.run(device: @device)
      end
    end
  end
end