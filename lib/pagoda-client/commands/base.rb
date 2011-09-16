module Pagoda
  module Command

    class Base
      
      def client
        @client ||= Pagoda::Auth.init
      end
      
      
        
    end



  end
end