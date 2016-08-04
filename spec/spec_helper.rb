require 'ramdo'
require 'timecop'

def os?(os)
  RUBY_PLATFORM =~ os
end
