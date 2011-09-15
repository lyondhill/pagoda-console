Dir[File.join(".", "**/*.rb")].each { |f| require f; puts f }


module Pagoda
end
