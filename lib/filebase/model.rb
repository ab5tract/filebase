require 'filebase/attributes'

class Filebase
  
  Error = RuntimeError
	
	module Model
	  
		def self.[]( path, driver=nil )
		  Module.new do |mixin|
		    ( class << mixin ; self ; end ).module_eval do
		      define_method( :included ) do | model |
  		      model.module_eval do
  		        storage = driver ? Filebase::Drivers.const_get(driver.to_s) : Filebase.storage
  		        @db = storage.new(path)
  		        extend Mixins::ClassMethods ; include Attributes ;  include Mixins::InstanceMethods
  		      end
  		    end
		    end
		  end
		end
		
		module Mixins
		  
		  module ClassMethods
		    attr_accessor :db
		    def create( assigns )
		      object = new( assigns )
		      raise Filebase::Error, "record already exists" if @db.has_key?(object["key"])
		      save( object )
	      end
		    def all ; @db.all.map { |attrs| new( attrs ) } ; end
		    
		    def find( key ) ; attrs = @db.find( key ); new( attrs ) if attrs ; end
		    alias_method :[], :find
		    
		    def keys; @db.keys; end
		    
		    def find_keys(keys)
		      @db.find_keys(keys).map { |h| new(h) if h }
		    end
		    
		    def slice(start, length)
		      k = self.keys.slice(start, length)
		      k ? find_keys(k) : []
		    end
		    
		    def reverse_slice(start, length)
		      k = self.keys.reverse.slice(start, length)
		      k ? find_keys(k) : []
		    end
		    
		    def count
		      @db.count
		    end
		    
		    def save( object )
		      key = object.key
		      raise( Filebase::Error, 'attempted to save an object with nil key' ) unless key and !key.empty?
          object if @db.write( key, object.to_h )
		    end
		    
		    def delete( object )
		      key = object.key
		      raise( Filebase::Error, 'attempted to delete an object with nil key' ) unless key and !key.empty?
		      @db.delete( object.key )
		    end
		    
		    def has_one( assoc_key, options = {} )
		      module_eval do
		        define_method assoc_key do
  	          foreign_class = options[:class] || Object.module_eval( assoc_key.to_s.camel_case )
  		        @has_one ||= {}
		          @has_one[assoc_key] ||= foreign_class.find( get( assoc_key ) ) 
		        end
		        define_method( assoc_key.to_s + '=' ) do | val |
  		        @has_one ||= {}; @has_one[assoc_key] = nil
		          set( assoc_key, String === val ? val : val.key )
		        end
		      end
		    end
		    
		    def has_many( assoc_key, options = {} )
		      module_eval do
		        define_method( assoc_key ) do
  	          foreign_class = options[:class] || Object.module_eval( assoc_key.to_s.camel_case )
		          @has_many ||= {}
		          @has_many[assoc_key] ||= ( get( assoc_key ) || [] ).uniq.map { |key| foreign_class.find( key ) } 
		        end
            # when we save, make sure to pick up any changes to the array
            (class<<self;self;end).module_eval do
              old_save = instance_method(:save)
              define_method :save do |object|
  		          object.set( assoc_key, object.send( assoc_key ).map{ |x| x.key }.uniq )
                object if old_save.bind(self).call(object)
              end
            end
          end
		    end
		    
		    def index_on( attribute, options={} )
		      storage = options[:driver] ? Filebase::Drivers.const_get(options[:driver].to_s) : @db.class
		      field_name = attribute.to_s
		      index ||= storage.new("#{@db.root}/indexes")
		      klass = self
		      (class<<self;self;end).module_eval do
            old_save = instance_method(:save)
            old_delete = instance_method(:delete)
            
            define_method :save do |object|
              key = object.key
              old_save.bind(self).call(object)
              field = index.find(field_name) || {}
              val = object[field_name]
              if val.is_a? Array
                val.each do |v|
                  list = (field[v.to_s] ||= [])
                  list << key unless list.include? key
                end
              else
                list = field[val.to_s] ||= []
                list << key unless list.include? key
              end
              object if index.write(field_name, field)
            end
            
            define_method :delete do |object|
              (field = index.find(field_name)) || return
              val = object[field_name].to_s
              field[val].delete(object.key)
              index.write(field_name, field)
              old_delete.bind(self).call(object)
            end
            
            define_method "find_by_#{field_name}" do |val|
              ids = index.find(field_name)[val]
              ids ? ids.map { |id| klass.find(id)  } : []
            end
          end
		    end
		    
		  end
		  
      module InstanceMethods
        def save ; self.class.save( self ) ; end
        def delete ; self.class.delete( self ) ; self ; end
        def ==(object)
          key == object.key if object.is_a? Attributes
        end
        def eql?(object) ; key == object.key ; end # this seems iffy
        def hash ; key.hash ; end
      end

		end
	
	end

end