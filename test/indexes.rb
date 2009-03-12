require "#{File.dirname(__FILE__)}/helpers"

FileUtils.rm_r("#{test_dir}/db/user") if File.exist?("#{test_dir}/db/user")

TestDriver = :JSON
IndexDriver = :Marshal


describe "A model with an index" do
  
  before do
    @class = Class.new do
      include Filebase::Model[ "#{test_dir}/db/user", TestDriver ]
      index_on :email, :driver => IndexDriver
    end
    @index = Class.new do
      include Filebase::Model[ "#{test_dir}/db/user/indexes", IndexDriver ]
    end
    @user1 = @class.create( :key => 'automatthew', :email => 'self@automatthew.com', :name => 'Matthew King')
    @user2 = @class.create( :key => 'dyoder', :email => 'dan@zeraweb.com', :name => 'Dan Yoder')
  end
  
  after do
    @user1.delete; @user2.delete
  end
  
  it "adds to the index on save" do
    @index.find(:email)["self@automatthew.com"].keys.should == ['automatthew']
    @index.find(:email)["dan@zeraweb.com"].keys.should == ['dyoder']
  end
  
  it "can find things by indexes" do
    @class.find_by_email("dan@zeraweb.com").first["name"].should == "Dan Yoder"
  end
  
end