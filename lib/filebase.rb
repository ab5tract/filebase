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