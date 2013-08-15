require "spec_helper"

describe Editstore::State do
  
  it "should have the correct six states, from cached values" do
    
    Editstore::State.wait.should == Editstore::State.find_by_name('wait')
    Editstore::State.ready.should == Editstore::State.find_by_name('ready')
    Editstore::State.in_process.should == Editstore::State.find_by_name('in process')
    Editstore::State.applied.should == Editstore::State.find_by_name('applied')
    Editstore::State.complete.should == Editstore::State.find_by_name('complete')
    Editstore::State.error.should == Editstore::State.find_by_name('error')
    Editstore::State.count.should == 6
    
  end
  
end