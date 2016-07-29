module Ramdo
  module Ramdisk
    class DarwinWrapper
      def initialize
      end

      def list
        disks = []

        line = Cocaine::CommandLine.new("hdiutil", "info")
        line.run.each_line do |line|
          if line =~ /^[=]+$/
            disks << {}
          elsif line =~ /^image-path[\s]+:[\s]+(ram:\/\/[0-9]+)/
            disks.last[:is_ram_disk] = true
          elsif line =~ /^(\/dev\/disk[0-9]+)[\s]+(\/Volumes\/[A-Za-z0-9_-]+)/
            disks.last[:path] = Regexp.last_match[2].strip
            disks.last[:device] = Regexp.last_match[1].strip
          elsif line =~ /^blockcount[\s]+:[\s]+([0-9]+)/
            size_in_mb = Regexp.last_match[1].to_i / 2048
            disks.last[:size] = Filesize.from("#{size_in_mb} MB")
          end
        end

        disks.map { |d| Instance.new(d) if d.has_key? :is_ram_disk }.compact
      end

      def create(size)
        size = Filesize.from(size) if size.is_a? String
        raise NotEnoughFreeRamException.new unless enough_ram? size

        # Allocate new RAM space
        line = Cocaine::CommandLine.new("hdiutil", "attach -nomount ram://#{(size.to('MB') * 2048).to_i}")
        device = line.run
        device.strip!

        # Format RAM disk
        line = Cocaine::CommandLine.new("diskutil", "erasevolume HFS+ 'ramdisk_#{SecureRandom.uuid}' #{device}")
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