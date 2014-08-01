require "spec_helper"

describe Editstore::State, :type => :model do
  
  it "should have the correct six states, from cached values" do
    
    expect(Editstore::State.wait).to eq(Editstore::State.find_by_name('wait'))
    expect(Editstore::State.ready).to eq(Editstore::State.find_by_name('ready'))
    expect(Editstore::State.in_process).to eq(Editstore::State.find_by_name('in process'))
    expect(Editstore::State.applied).to eq(Editstore::State.find_by_name('applied'))
    expect(Editstore::State.complete).to eq(Editstore::State.find_by_name('complete'))
    expect(Editstore::State.error).to eq(Editstore::State.find_by_name('error'))
    expect(Editstore::State.count).to eq(6)
    
  end
  
end