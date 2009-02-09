module Attributes
  
	def initialize( assigns = {} ) ; self.attributes = assigns ; end
	
	def attributes=( hash )
	  @attrs = {}; hash.each { |k,v| @attrs[k.to_s] = v }
	end
	
	def attributes ; @attrs ||= {} ; end
	
	def has_key?( key ) ; @attrs.has_key?( key.to_s ) ; end
	
	def delete( key ) ; @attrs.delete( key.to_s ) ; end
	
	def method_missing(name,*args)
	  if args.empty?
      get(name.to_s)
    elsif (name = name.to_s) =~ /=$/
      set(name.chop, args[0])
    else
      super
    end
	end
	
	def [](name)
	  if ( rval = @attrs[name = name.to_s] ).is_a?( Hash )
	    @attrs[name] = self.class.new( rval )
    else
      rval
    end  
	end
	
	def []=(name,val) ; @attrs[name.to_s] = val ; end
	
	def to_h ; @attrs ; end
	
	alias :set :[]=
	alias :get :[]
  alias :to_hash :to_h
  
	
end
