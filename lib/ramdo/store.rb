module Ramdo
  class Store
    NAME_PATTERN = /^ramdo_([a-z0-9]+)_([0-9]+)$/

    attr_reader :file, :dir

    def initialize(opts = {})
      wrapper = Ramdisk::Factory.get
      list = wrapper.list
      disk = nil
      if list.length <= 0
        # Create a new Ramdisk
        disk = wrapper.create(DEFAULTS[:disk_size])
      else
        # Use one which is large enough
        list.each { |d| disk = d if d.size >= Filesize.from(DEFAULTS[:disk_size]) }
        disk = wrapper.create(DEFAULTS[:disk_size]) if disk.nil?
      end

      # Every time a new store is created we check if any other store is out of date
      Cleaner.clean_up(disk)

      ext = opts[:extension] ? opts[:extension].sub('.', '') : 'bin'
      uuid = SecureRandom.hex(4)
      timestamp = Time.now.utc.to_i
      @dir = File.join(disk.path, "ramdo_#{uuid}_#{timestamp}")
      @file = File.join(@dir, "store.#{ext}")

      Dir.mkdir(@dir)

      self.data = opts[:data] if opts.has_key?(:data)
    end

    def data=(data)
      IO.binwrite(@file, data)
    end

    def data
      IO.binread(@file)
    end

    def truncate
      return if @dir.empty? || @dir == File::SEPARATOR # Safety net
      FileUtils.rm_r @dir, :force => true
    end
  end
end