require 'rubygems'
require 'filebase/drivers/json'

class Filebase
  class << self ; attr_accessor :storage ; end
  self.storage = Drivers::JSON
end

class String
  unless method_defined?(:camel_case)
    def camel_case
      gsub(/(_)(\w)/) { $~[2].upcase }.gsub(/^([a-z])/) { $~[1].upcase }
    end
  end
end