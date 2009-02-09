require 'rubygems'
require 'filebase/drivers/mixin'
require 'filebase/drivers/json'

class Filebase
  class << self ; attr_accessor :storage ; end
  self.storage = Drivers::JSON
  
  attr_accessor :storage
  
	def initialize( root = '.', storage = nil )
		@storage = ( storage || Filebase.storage ).new( root )
	end
	
end

class String
  unless method_defined?(:camel_case)
    def camel_case
      # It sucks that you can't do this thread safely.
      gsub(/(_)(\w)/) { |m| m.upcase }.gsub(/^([a-z])/) { $1.upcase }
    end
  end
end