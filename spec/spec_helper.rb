require 'bundler/setup'
# require 'fakefs'
require 'pagoda/cli/helpers'
require 'pagoda/cli/core_ext'

def silently(&block)
  warn_level = $VERBOSE
  $VERBOSE = nil
  result = block.call
  $VERBOSE = warn_level
  result
end