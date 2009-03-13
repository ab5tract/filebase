require 'json'
require 'fileutils'
class Filebase
  module Drivers
    class JSON
      include Mixin
      
      def initialize( root )
        super
        @extension = "json"
      end

    	def all
        Dir["#{@root}/*.json"].map do |file|
          obj = File.open(file) { |f| ::JSON.load(f) }
          obj['key'] = File.basename(file, '.json') if obj.is_a? Hash
          obj or nil
        end
    	end

      def find( key )
        obj = File.open( path(key) ) { |f| ::JSON.load(f) } rescue nil
    		obj['key'] = key if obj.is_a? Hash
    		obj or nil # convert false to nil
    	end
    	
      def find_keys(keys)
        keys.map do |key|
          obj = File.open( path(key) ) { |f| ::JSON.load(f) } rescue nil
      		obj['key'] = key if obj.is_a? Hash
      		obj or nil # convert false to nil
        end
      end

    	def write( key, hash )
        File.open(path(key), "w") do |f|
          begin
            f.puts ::JSON.pretty_generate(hash)
            true
          rescue
            nil
          end
        end
    	end

  	end
  end


end