require 'cocaine'
require 'pp'
require 'filesize'
require 'securerandom'
require 'fileutils'

require 'ramdo/version'
require 'ramdo/exceptions'
require 'ramdo/disk_instance'
require 'ramdo/store'
require 'ramdo/cleaner'

module Ramdo
  DEFAULTS = {
    ttl: 3600 # In seconds
  }
end