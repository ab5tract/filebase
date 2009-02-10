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
		    
		    def save( object )
		      key = object.key
		      raise( Filebase::Error, 'attempted to save an object with nil key' ) unless key and !key.empty?
          @db.write( key, object.to_h ) and object
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
              alias_method :has_many_save, :save
              define_method :save do |object|
  		          object.set( assoc_key, object.send( assoc_key ).map{ |x| x.key }.uniq )
                has_many_save(object)
              end
            end
          end
		    end
		    
		    def index_on( attribute )
		      index ||= @db.class.new("#{@db.root}/indexes")
		      (class<<self;self;end).module_eval do
            alias_method :index_on_save, :save
            class_name = self.class.name
            define_method :save do |object|
              index_on_save(object)
              class_index = index.find(class_name)
              class_index[attribute] << object.key
              class_index.save
            end
          end
		    end
		    
		  end
		  
      module InstanceMethods
        def save ; self.class.save( self ) ; end
        def delete ; self.class.delete( self ) ; self ; end
        def ==(object) ; key == object.key ; end
        def eql?(object) ; key == object.key ; end # this seems iffy
        def hash ; key.hash ; end
      end

		end
	
	end

end