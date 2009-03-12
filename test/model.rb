require "#{File.dirname(__FILE__)}/helpers"

class Person
  include Filebase::Model[ "#{test_dir}/db/person", :YAML ]
end

class Organization
  include Filebase::Model[ "#{test_dir}/db/organization", :YAML ]
  index_on :name
end

# Marshal format varies between Ruby versions.  To generate the marshal data files,
# uncomment the below lines and run, then comment again.
# Organization.create :key => "acme.com", :name => "Acme, Inc.", :members => [ "joe@acme.com"]
# Person.create(:key => "joe@acme.com", :organization => "acme.com", :name => "Joe Smith")

describe 'A filebase' do

  it 'should allow you to load all records from a given database' do
    Person.all.size.should == 1
  end

  it 'should allow you to access an existing record' do
    Person.find( 'joe@acme.com' ).name.should == 'Joe Smith'
    Person['joe@acme.com'].name.should == 'Joe Smith'
  end
  
  it 'should return nil if the record does not exist' do
    Person.find('jane@acme.com').should == nil
  end
  
  it 'should allow you to create a new record' do
    Person.create( :key => 'jane@acme.com', :name => 'Jane Smith' )
    Person.find( 'jane@acme.com' ).name.should == 'Jane Smith'
  end
  
  it "raises when you try to create a record that already exists" do
    lambda do
      Person.create( :key => 'joe@acme.com', :name => 'Joe Blow' )
    end.should.raise
  end
  
  it 'should allow you to modify a record and save the change' do
    jane = Person.find( 'jane@acme.com' )
    jane.name = 'Jane Doe' ; jane.save
    Person.find( 'jane@acme.com' ).name.should == 'Jane Doe'
  end

  it "should allow you to create new attributes out of thin air" do
    jane = Person.find( 'jane@acme.com' )
    jane.gender = 'Female' ; jane.save
    Person.find( 'jane@acme.com' ).gender.should == 'Female'
  end
  
  it 'should allow you to delete a record' do
    Person.find('jane@acme.com').delete
    Person.find('jane@acme.com').should == nil
  end
  
  it 'should raise an exception if you save an object without a key' do
    lambda { Person.create( :name => 'Jane Smith' ) }.should.raise( Filebase::Error )
  end  
  
end