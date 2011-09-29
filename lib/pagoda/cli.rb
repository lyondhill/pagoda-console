# Dir[File.join(".", "**/*.rb")].each { |f| print require f; puts f}
require 'pagoda/cli/version'
require 'pagoda/cli/string_ext'
require 'pagoda/cli/helpers'
require 'pagoda/cli/auth'
require 'pagoda/cli/runner'
require 'pagoda/cli/commands'

module Pagoda
  module CLI

  end
end
