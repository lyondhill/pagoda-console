require 'bundler/setup'
# require 'fakefs'

require 'pagoda'

def silently(&block)
  warn_level = $VERBOSE
  $VERBOSE = nil
  result = block.call
  $VERBOSE = warn_level
  result
end