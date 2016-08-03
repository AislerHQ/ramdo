module Ramdo
  class Cleaner
    def self.clean_up(disk)
      Dir.entries(disk.path).each do |dir|
        if dir =~ Store::NAME_PATTERN
          uuid = Regexp.last_match[1]
          timestamp = Regexp.last_match[2].to_i
          if (timestamp + DEFAULTS[:ttl]) < Time.now.utc.to_i
            FileUtils.rm_r File.join(disk.path, dir), :force => true
          end
        end
      end
    end
  end
end