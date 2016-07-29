module Ramdo
  module Ramdisk
    class Instance
      NAME_PATTERN = /ramdo_[A-Za-z0-9_-]+$/

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
        wrapper = Ramdisk::Factory.get
        wrapper.destroy self
      end
    end
  end
end
