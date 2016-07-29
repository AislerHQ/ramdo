module Ramdo
  class Store
    attr_reader :file, :uuid

    def initialize
      wrapper = Ramdisk::Factory.get
      list = wrapper.list
      if list.length <= 0
        # Create a new Ramdisk
        @disk = wrapper.create(DEFAULT_RAMDISK_SIZE)
      else
        # Use one which is large enough
        list.each { |disk| @disk = disk if disk.size >= Filesize.from(DEFAULT_RAMDISK_SIZE) }
        @disk = wrapper.create(DEFAULT_RAMDISK_SIZE) if @disk.nil?
      end

      @uuid = SecureRandom.uuid
      @filename = 'ramdo_' + @uuid
      @file = [@disk.path, @filename].join('/') # No Windows support!
    end

    def data=(data)
      IO.write(@file, data)
    end

    def data
      IO.read(@file)
    end

    def truncate
      File.delete(@file)
    end
  end
end