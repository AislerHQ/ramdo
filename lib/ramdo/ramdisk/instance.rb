module Ramdo
  module Ramdisk
    class Instance
      NAME_PATTERN = /^ramdo_disk_([a-z0-9]+)$/

      def self.generate_name
        "ramdo_disk_#{SecureRandom.hex(4)}"
      end

      attr_accessor :device, :path, :size

      def initialize(wrapper, info = {})
        @wrapper = wrapper
        @device = info[:device]
        @path = info[:path]
        @size = info[:size]
      end

      def destroy!
        @wrapper.destroy self
      end
    end
  end
end
