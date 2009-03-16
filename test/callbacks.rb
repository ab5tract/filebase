require "#{File.dirname(__FILE__)}/helpers"

FileUtils.rm_r("#{test_dir}/db/user") if File.exist?("#{test_dir}/db/user")

describe "A model with callbacks" do
  
  before do
    @class = Class.new do
      include Filebase::Model[ "#{test_dir}/db/user", :JSON ]
      index_on :first, :driver => :JSON
    end
    @index = Class.new do
      include Filebase::Model[ "#{test_dir}/db/user/indexes", :JSON ]
    end
  end
  
  it "can perform actions before save" do
    @class.before_save do |object|
      object['monkey'] = 'me'
    end
    
    user1 = @class.create(:key => 'funky')
    @class.find('funky')['monkey'].should == 'me'
  end
  
  it "can perform actions after save" do
    keys = []
    @class.after_save do |object|
      keys << object['key']
    end
    
    user1 = @class.create(:key => 'lunky')
    keys.should == ['lunky']
  end
  
  it "can perform actions before and after delete" do
    keys = []
    @class.after_delete do |object|
      keys << "monkey"
    end
    @class.before_delete do |object|
      keys << object['key']
    end
    
    user1 = @class.create(:key => 'dunky')
    user1.delete
    keys.should == ['dunky', 'monkey']
  end
  
end
  