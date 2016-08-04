module Ramdo
  module Ramdisk
    class LinuxWrapper
      def initialize
        line = Cocaine::CommandLine.new("cat", "/proc/mounts")
        line.run.each_line do |line|
          @shm_path = Regexp.last_match[1] if line =~ /(\/[a-z]+\/shm)[\s]tmpfs[\s]rw/
        end
        raise GeneralRamdiskException.new("shm path not found") unless @shm_path
      end

      def list
        disks = []
        Dir.glob(@shm_path + '/*').each do |dir|
          if dir.split(File::SEPARATOR).last =~ Instance::NAME_PATTERN
            disks << Instance.new(self, path: dir, device: @shm_path, size: Filesize.from("1 GB"))
          end
        end

        disks
      end

      def create(size)
        size = Filesize.from(size) if size.is_a? String
        raise NotEnoughFreeRamException.new unless enough_ram? size

        # Create new directory as dedicated space
        path = File.join(@shm_path, Instance.generate_name)
        Dir.mkdir(path)

        # Receive all disk and select just created one
        list().select { |disk| disk.path == path }.first
      end

      def destroy(instance)
        return false unless File.exist? instance.path
        FileUtils.rm_r instance.path, :force => true
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
