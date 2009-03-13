require 'yaml'
require 'fileutils'
class Filebase
  
  module Drivers
    class YAML
      include Mixin

      def initialize( root )
        super
        @extension = "yml"
      end

    	def all
        Dir["#{@root}/*.yml"].map do |file|
         obj = ::YAML.load_file(file) 
         obj['key'] = File.basename(file, '.yml') if obj.is_a? Hash
         obj or nil
        end
    	end

      def find( key )
    		obj = ::YAML.load_file( path( key ) ) rescue nil
    		obj['key'] = key if obj.is_a? Hash
    		obj or nil # convert false to nil
    	end
    	
    	def find_keys(keys)
        keys.map do |key|
          obj = ::YAML.load_file( path( key ) ) rescue nil
      		obj['key'] = key if obj.is_a? Hash
      		obj or nil # convert false to nil
        end
      end

    	def write( key, object )
  		  object if File.open( path(key), "w" ) { |f| ::YAML.dump(object, f) }
    	end

  	end
  end

end