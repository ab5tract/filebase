require 'json'
require 'fileutils'
class Filebase
  
  class JSON
    
    def initialize( root )
      @root = root.to_s
    end
    
  	def path( key )
  	  "#{@root}/#{key}.json"
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
  	
  	def save( key, object )
		  object if File.open( path(key), "w" ) { |f| f.print ::JSON.pretty_generate(object) }
  	end
  	
  	def delete( key )
  		::FileUtils.remove( path( key ) )
	  end
	  
	end

end