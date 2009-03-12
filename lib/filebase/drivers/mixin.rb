require 'fileutils'
class Filebase
  module Drivers
    module Mixin
      
      def initialize(root)
        @root = root.to_s
        FileUtils.mkdir_p(root) unless File.exist?(root)
      end
      
      def root
        @root
      end
      
      def path( key )
        raise Filebase::Error, "can't generate a path using a nil key" unless key
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