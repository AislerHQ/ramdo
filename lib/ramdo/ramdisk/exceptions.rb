module Ramdo
  module Ramdisk
    class OSNotSupportedException < StandardError; end
    class NotEnoughFreeRamException < StandardError; end
  end
end