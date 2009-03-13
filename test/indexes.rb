require "#{File.dirname(__FILE__)}/helpers"

FileUtils.rm_r("#{test_dir}/db/user") if File.exist?("#{test_dir}/db/user")

TestDriver = :JSON
IndexDriver = :JSON


describe "A model with an index" do
  
  before do
    @class = Class.new do
      include Filebase::Model[ "#{test_dir}/db/user", TestDriver ]
      index_on :first, :driver => IndexDriver
    end
    @index = Class.new do
      include Filebase::Model[ "#{test_dir}/db/user/indexes", IndexDriver ]
    end
    @user1 = @class.create( :key => 'automatthew', :email => 'self@automatthew.com', :first => 'Matthew')
    @user2 = @class.create( :key => 'dyoder', :email => 'dan@zeraweb.com', :first => 'Dan')
    @user3 = @class.create( :key => 'ddonnell', :email => 'ddonnell@attinteractive.com', :first => 'Dan')
  end
  
  after do
    @user1.delete; @user2.delete; @user3.delete
  end
  
  it "adds to the index on save" do
    @index.find(:first)["Matthew"].should == ['automatthew']
    @index.find(:first)["Dan"].sort.should == ['dyoder', 'ddonnell'].sort
  end
  
  it "does not duplicate index entries" do
    @user1.save
    @index.find(:first)["Matthew"].should == ['automatthew']
  end
  
  it "can find things by indexes" do
    @class.find_by_first("Matthew").first["email"].should == "self@automatthew.com"
    @class.find_by_first("Smurf").should.be.empty
  end
  
  it "removes from the index on delete" do
    user4 = @class.create( :key => 'jrush', :email => 'jrush@attinteractive.com', :first => 'Jason')
    user4.delete
    @index.find(:first)["Jason"].should == []
    @class.find_by_first("Jason").should.be.empty
  end
  
  it "is not stupid about array values" do
    user5 = @class.create(:key => 'jjjschmidt', 
      :email => 'jjjschmidt@attinteractive.com', :first => %w{ John Jacob Jingleheimer} )
    
    @index.find(:first)["John"].should == ['jjjschmidt']
    @index.find(:first)["Jacob"].should == ['jjjschmidt']
    @index.find(:first)["Jingleheimer"].should == ['jjjschmidt']
  end
  
end