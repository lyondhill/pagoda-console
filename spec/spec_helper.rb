require 'bundler/setup'
# require 'fakefs'
require 'pagoda/cli/helpers'

def silently(&block)
  warn_level = $VERBOSE
  $VERBOSE = nil
  result = block.call
  $VERBOSE = warn_level
  result
end