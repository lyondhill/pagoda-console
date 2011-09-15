Dir[File.join(".", "**/*.rb")].each { |f| print require f; puts f}


module Pagoda
end
