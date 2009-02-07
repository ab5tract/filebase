require 'fileutils'
class Filebase
  module Drivers
    module Mixin
            
      def path( key )
        "#{@root}/#{key}.#{@extension}"
      end

      def has_key?( key )
        File.exist?( path(key) )
      end
      
      def delete( key )
    		::FileUtils.remove( path( key ) )
  	  end
      
    end
  end
end