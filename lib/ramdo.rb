require 'cocaine'
require 'pp'
require 'filesize'
require 'securerandom'
require 'fileutils'

require 'ramdo/version'
require 'ramdo/exceptions'
require 'ramdo/ramdisk/factory'
require 'ramdo/ramdisk/instance'
require 'ramdo/ramdisk/darwin_wrapper'
require 'ramdo/ramdisk/linux_wrapper'
require 'ramdo/ramdisk/generic_wrapper'
require 'ramdo/store'
require 'ramdo/cleaner'

module Ramdo
  DEFAULTS = {
    disk_size: '100mb',
    ttl: 3600 # In seconds
  }
end