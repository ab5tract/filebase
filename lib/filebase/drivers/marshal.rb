require 'fileutils'
class Filebase
  
  class Marshal
    
    def initialize( root )
      @root = root.to_s
    end
    
  	def path( key )
  	  "#{@root}/#{key}.marshal"
  	end
  	
  	def all
      Dir["#{@root}/*.marshal"].map do |file|
        obj = File.open(file) { |f| ::Marshal.load(f) }
        obj['key'] = File.basename(file, '.marshal') if obj.is_a? Hash
        obj or nil
      end
  	end
    
    def find( key )
      obj = File.open( path(key) ) { |f| ::Marshal.load(f) } rescue nil
  		obj['key'] = key if obj.is_a? Hash
  		obj or nil # convert false to nil
  	end
  	
  	def save( key, object )
		  object if File.open( path(key), "w" ) { |f| ::Marshal.dump(object, f) }
  	end
  	
  	def delete( key )
  		::FileUtils.remove( path( key ) )
	  end
	  
	end

end