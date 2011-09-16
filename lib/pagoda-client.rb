# Dir[File.join(".", "**/*.rb")].each { |f| print require f; puts f}
require 'pagoda-client/version'
require 'pagoda-client/string_ext'
require 'pagoda-client/helpers'
require 'pagoda-client/auth'
require 'pagoda-client/client'
require 'pagoda-client/runner'

module Pagoda

end
