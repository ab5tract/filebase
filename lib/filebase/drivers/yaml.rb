require 'yaml'
require 'fileutils'
class Filebase
  
  module Drivers
    class YAML
      include Mixin

      def initialize( root )
        @root = root.to_s
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

    	def save( key, object )
  		  object if File.open( path(key), "w" ) { |f| ::YAML.dump(object, f) }
    	end

  	end
  end

end