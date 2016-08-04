module Ramdo
  module Ramdisk
    class GenericWrapper
      def initialize
        @tmp_path = '/tmp'
        raise GeneralRamdiskException.new("tmp path not found") unless @tmp_path && Dir.exist?(@tmp_path)
      end

      def list
        disks = []
        Dir.glob(@tmp_path + '/*').each do |dir|
          if dir.split(File::SEPARATOR).last =~ Instance::NAME_PATTERN
            disks << Instance.new(self, path: dir, device: @tmp_path, size: Filesize.from("1 GB"))
          end
        end

        disks
      end

      def create(size)
        # Create new directory as dedicated space
        path = File.join(@tmp_path, Instance.generate_name)
        Dir.mkdir(path)

        # Receive all disk and select just created one
        list().select { |disk| disk.path == path }.first
      end

      def destroy(instance)
        return false unless Dir.exist? instance.path
        FileUtils.rm_r instance.path, :force => true
      end

      private
      def enough_ram?(size)
        # As the generic wrapper does not use RAM always return true
        true
      end
    end
  end
end
