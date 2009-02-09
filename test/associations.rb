require "#{File.dirname(__FILE__)}/helpers"
require 'filebase'
require 'filebase/drivers/json'
require 'filebase/drivers/yaml'
require 'filebase/drivers/marshal'
require 'filebase/model'

class Person
  include Filebase::Model[ "#{test_dir}/db/person" ]
  has_one :organization
end

class Organization
  include Filebase::Model[ "#{test_dir}/db/organization", :JSON ]
  has_many :members, :class => Person
end

describe "Filebase" do
  
  it "should allow a 'has-one' association" do
    joe = Person.find('joe@acme.com'); joe.organization = Organization.find('acme.com'); joe.save
    Person.find('joe@acme.com').organization.key.should == 'acme.com'
  end
  
  it "should allow a 'has-many' association'" do
    acme = Organization.find('acme.com'); acme.members << Person.find('joe@acme.com'); acme.save
    acme.members.include?( Person.find( 'joe@acme.com' )).should == true
  end
  
end
