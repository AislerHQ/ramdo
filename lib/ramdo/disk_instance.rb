module Ramdo
  class DiskInstance
    NAME_PATTERN = /^ramdo_disk_([a-z0-9]+)$/

    def self.list
      disks = []
      Dir.glob('/tmp/*').each do |dir|
        if (dir.split(File::SEPARATOR).last =~ NAME_PATTERN) && File.writable?(dir)
          disks << self.new(dir)
        end
      end

      disks
    end

    def self.create
      path = File.join('/tmp', self.generate_name)
      Dir.mkdir(path)

      self.new(path)
    end

    def self.generate_name
      "ramdo_disk_#{SecureRandom.hex(4)}"
    end

    attr_accessor :path

    def initialize(path)
      @path = path
    end

    def destroy!
      return false unless Dir.exist? @path
      FileUtils.rm_r @path, :force => true
    end
  end
end
