module Ramdo
  module Ramdisk
    class LinuxWrapper
      def initialize
        @shm_path = "/dev/shm"
      end

      def list
        disks = []

        found_shm = false
        line = Cocaine::CommandLine.new("cat", "/proc/mounts")
        line.run.each_line do |line|
          found_shm ||= line =~ /^tmpfs \/dev\/shm tmpfs/
        end
        raise GeneralRamdiskException.new("#{@shm_path} not found") unless found_shm

        Dir.glob(@shm_path + '/*').each do |dir|
          if dir =~ Instance::NAME_PATTERN
            disks << Instance.new(path: dir, device: @shm_path, size: Filesize.from("1 GB"))
          end
        end

        disks
      end

      def create(size)
        size = Filesize.from(size) if size.is_a? String
        raise NotEnoughFreeRamException.new unless enough_ram? size

        # Create new directory as dedicated space
        path = [@shm_path, Instance.generate_name].join('/')
        Dir.mkdir(path)

        # Receive all disk and select just created one
        list().select { |disk| disk.path == path }.first
      end

      def destroy(instance)
        return false unless File.exist? instance.path

        Dir.glob(instance.path + "/*").each { |file| File.delete(file) if File.file? file }
        Dir.rmdir(instance.path)
      end

      private
      def enough_ram?(size)
        size = Filesize.from(size) if size.is_a? String
        free_mem = ""

        line = Cocaine::CommandLine.new("cat", "/proc/meminfo")
        line.run.each_line do |line|
          if line =~ /^MemFree:[\s]+([0-9]+ kB)/
            free_mem = Regexp.last_match[1]
          end
        end

        Filesize.from(free_mem) > size
      end
    end
  end
end
