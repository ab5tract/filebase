require "#{File.dirname(__FILE__)}/helpers"

class Person
  include Filebase::Model[ "#{test_dir}/db/person", :JSON ]
end

class Organization
  include Filebase::Model[ "#{test_dir}/db/organization", :JSON ]
  index_on :name
end

class Thing
  include Filebase::Model[ "#{test_dir}/db/thing", :JSON ]
end

# Marshal format varies between Ruby versions.  To generate the marshal data files,
# uncomment the below lines and run, then comment again.
# Organization.create :key => "acme.com", :name => "Acme, Inc.", :members => [ "joe@acme.com"]
# Person.create(:key => "joe@acme.com", :organization => "acme.com", :name => "Joe Smith")

describe 'A filebase' do

  it 'allows you to load all records from a given database' do
    Person.all.size.should == 1
  end
  
  it 'can find multiple keys' do 
    items = Thing.find_keys( "a", "c", "e" )
    items.size.should == 3
    items.last.key.should == "e"
  end
  
  it "can return a page of results" do
    start, length = 2, 4
    things = Thing.slice(start, length)
    things.size.should == 4
    things.map { |t| t.key }.should == %w{ c d e f }
  end

  it 'allows you to access an existing record' do
    Person.find( 'joe@acme.com' ).name.should == 'Joe Smith'
    Person['joe@acme.com'].name.should == 'Joe Smith'
  end
  
  it 'returns nil if the record does not exist' do
    Person.find('jane@acme.com').should == nil
  end
  
  it 'allows you to create a new record' do
    Person.create( :key => 'jane@acme.com', :name => 'Jane Smith' )
    Person.find( 'jane@acme.com' ).name.should == 'Jane Smith'
  end
  
  it "raises when you try to create a record that already exists" do
    lambda do
      Person.create( :key => 'joe@acme.com', :name => 'Joe Blow' )
    end.should.raise
  end
  
  it 'allows you to modify a record and save the change' do
    jane = Person.find( 'jane@acme.com' )
    jane.name = 'Jane Doe' ; jane.save
    Person.find( 'jane@acme.com' ).name.should == 'Jane Doe'
  end

  it "allows you to create new attributes out of thin air" do
    jane = Person.find( 'jane@acme.com' )
    jane.gender = 'Female' ; jane.save
    Person.find( 'jane@acme.com' ).gender.should == 'Female'
  end
  
  it 'allows you to delete a record' do
    Person.find('jane@acme.com').delete
    Person.find('jane@acme.com').should == nil
  end
  
  it 'should raise an exception if you save an object without a key' do
    lambda { Person.create( :name => 'Jane Smith' ) }.should.raise( Filebase::Error )
  end  
  
end