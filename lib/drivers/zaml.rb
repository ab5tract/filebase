require 'zaml'
class Filebase
  
  class ZAML
    
    def initialize( root )
      @root = root.to_s
    end
    
  	def path( key )
  	  "#{@root}/#{key}.yml"
  	end
  	
  	def all
  	  Dir['*.yml'].map do |file|
  	   obj = ::ZAML.load_file(file) 
  	   obj['key'] = File.basename(file, '.yml') if obj.is_a? Hash
  	   obj or nil
  	  end
  	end
    
    def find( key )
  		obj = ::ZAML.load_file( path( key ) ) rescue nil
  		obj['key'] = key if obj.is_a? Hash
  		obj or nil # convert false to nil
  	end
  	
  	def save( key, object )
  	  object if File.open( path(key) ) { |f| ::ZAML.dump(object, f) }
  	end
  	
  	def delete( key )
  		FileUtils.remove( path( key ) )
	  end
	  
	end

end