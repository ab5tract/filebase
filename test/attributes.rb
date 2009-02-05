require 'rubygems'
require 'bacon'
Bacon.extend Bacon::TestUnitOutput
Bacon.summary_on_exit


$:.unshift "#{HERE = File.dirname(__FILE__)}../lib"
require 'filebase/attributes'

describe "An attributified object" do
  
  before do
    @superclass = Class.new do
      def method_missing(*args)
        "bogus method_missing"
      end
    end
    @class = Class.new(@superclass) do
      include Attributes
    end
    @thing = @class.new
  end
  
  it "initializes with a hash, or other pairwise object" do
    thing = @class.new( "smurf" => "nuts")
    thing.attributes.should == { "smurf" => "nuts" }
    thing = @class.new( [ ["pixie", "raisins"] ])
    thing.attributes.should == { "pixie" => "raisins" }
  end
  
  it "converts the keys of init hash to strings" do
    thing = @class.new( :smurf => "nuts", 3 => "blind smurfs")
    thing.attributes.should == { "smurf" => "nuts", "3" => "blind smurfs" }
  end
  
  it "can get and set attributes" do
    @thing.set "smurf", "nuts"
    @thing.get("smurf").should == "nuts"
  end
  
  it "can set and get attrs using index operators" do
    @thing["smurf"] = "nuts"
    @thing["smurf"].should == "nuts"
  end
  
  it "can detect the presence of a key" do
    @thing.set "smurf", "nuts"
    @thing.has_key?("smurf").should.be.true
    @thing.has_key?("pixie").should.be.false
  end
  
  it "can delete an attribute with Hashlike consequences" do
    @thing.set "smurf", "nuts"
    @thing.delete("smurf").should == "nuts"
    @thing.attributes.should.be.empty
  end
  
  it "uses method_missing to provide getter/setter methods using the key name" do
    @thing.smurf = "nuts"
    @thing.smurf.should == "nuts"
    @thing.not_here("foo").should == "bogus method_missing"
  end
  
  it "ensures that sub-hashes are also attributified" do
    @thing["subhash"] = { :smurf => "nuts" }
    @thing.get("subhash").smurf.should == "nuts"
  end
  
  it "may spit out attributes as a Hash upon demand" do
    @thing.set "smurf", "nuts"
    @thing.to_h.should == { "smurf" => "nuts" }
  end
  
  it "can use as a key anything that becomes the right key when #to_s-ified" do
    @thing.set "smurf", "nuts"
    @thing.set "3", "blind smurfs"
    @thing.get("smurf").should == "nuts"
    @thing.get(:smurf).should == "nuts"
    @thing[:pixie] = "raisins"
    @thing[:pixie].should == "raisins"
    @thing.get(3).should == "blind smurfs"
    @thing.set :mixed, "nuts"
    @thing.get(:mixed).should == "nuts"
    @thing.has_key?(:smurf).should.be.true
    @thing.delete(:smurf).should == "nuts"
  end
  
end