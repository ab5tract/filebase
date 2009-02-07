require 'yaml'
require 'fileutils'
class Filebase
  
  class YAML
    Filebase.storage = self
    
    def initialize( root )
      @root = root.to_s
    end
    
  	def path( key )
  	  "#{@root}/#{key}.yml"
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
  	
  	def delete( key )
  		::FileUtils.remove( path( key ) )
	  end
	  
	end

end