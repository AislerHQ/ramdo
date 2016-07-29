module Ramdo
  module Ramdisk
    class LinuxWrapper
      def initialize
      end

      def list
        disks = []

        found_shm = false
        line = Cocaine::CommandLine.new("cat", "/proc/mounts")
        line.run.each_line do |line|
          found_shm ||= line =~ /^tmpfs \/dev\/shm tmpfs/
        end
        raise GeneralRamdiskException.new('/dev/shm not mounted') unless found_shm

        Dir.glob('/dev/shm').each do |dir|
          if dir =~ Instance.NAME_PATTERN
            disks << Instance.new(path: dir, device: '/dev/shm', size: Filesize.from(" MB"))
          end
        end

      end

      def create(size)
        size = Filesize.from(size) if size.is_a? String
        raise NotEnoughFreeRamException.new unless enough_ram? size

        # Allocate new RAM space
        line = Cocaine::CommandLine.new("hdiutil", "attach -nomount ram://#{(size.to('MB') * 2048).to_i}")
        device = line.run
        device.strip!

        # Format RAM disk
        line = Cocaine::CommandLine.new("diskutil", "erasevolume HFS+ '#{Instance.generate_name}' #{device}")
        line.run

        # Receive all disk and select just created one
        list().select { |disk| disk.device == device }.first
      end

      private
      def enough_ram?(size)
        size = Filesize.from(size) if size.is_a? String
        pages_free = 0
        page_size = 0

        line = Cocaine::CommandLine.new("vm_stat")
        line.run.each_line do |line|
          if line =~ /^Pages free:[\s]+([0-9]+)./
            pages_free = Regexp.last_match[1].to_i
          elsif line =~ /^Mach Virtual Memory Statistics: +\(page size of ([0-9]+) bytes\)/
            page_size = Regexp.last_match[1].to_i
          end
        end

        Filesize.new(pages_free * page_size) > size
      end
    end
  end
end
