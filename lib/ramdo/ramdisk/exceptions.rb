module Ramdo
  module Ramdisk
    class OSNotSupportedException < StandardError; end
    class NotEnoughFreeRamException < StandardError; end
    class GeneralRamdiskException < StandardError; end
  end
end
