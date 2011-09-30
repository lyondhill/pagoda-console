# Dir[File.join(".", "**/*.rb")].each { |f| print require f; puts f}
require 'pagoda/cli/version'
require 'pagoda/cli/core_ext'
require 'pagoda/cli/helpers'
require 'pagoda/cli/config'
require 'pagoda/cli/commands'

module Pagoda
  module CLI

  end
end
