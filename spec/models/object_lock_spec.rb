require 'spec_helper'

describe Editstore::ObjectLock do
  
  it "should add the druid: prefix if missing" do
    
    pids=['druid:oo000oo0001','oo000oo0002']
    
    Editstore::ObjectLock.get_pid(pids[0]).should == 'druid:oo000oo0001'
    Editstore::ObjectLock.get_pid(pids[1]).should == 'druid:oo000oo0002'

  end
  
  it "should lock an object, with or without druid: prefix" do
       
    pids=['druid:oo000oo0001','oo000oo0002']
    
    pids.each do |pid|
      puts pid
      obj=Editstore::ObjectLock.find_by_druid(Editstore::ObjectLock.get_pid(pid)) 
      obj.should be_nil
    
      Editstore::ObjectLock.locked?(pid).should be_false

      Editstore::ObjectLock.lock(pid).should be_true

      Editstore::ObjectLock.locked?(pid).should be_true
    
      obj=Editstore::ObjectLock.find_by_druid(Editstore::ObjectLock.get_pid(pid)) 
      obj.locked.should_not be_nil

      Editstore::ObjectLock.lock(pid).should be_false #can't lock again
      Editstore::ObjectLock.unlock(pid).should be_true
    
      obj.unlock.should be_true
    
      Editstore::ObjectLock.locked?(pid).should be_false
      obj.reload
      obj.locked.should be_nil
    end
    
  end

  it "should unlock an object" do

     pid='druid:oo000oo0002'

     obj=Editstore::ObjectLock.create(:druid=>pid,:locked=>Time.now) 
     obj.should_not be_nil

     Editstore::ObjectLock.locked?(pid).should be_true
     Editstore::ObjectLock.lock(pid).should be_false

     Editstore::ObjectLock.unlock(pid).should be_true

     Editstore::ObjectLock.locked?(pid).should be_false

     obj=Editstore::ObjectLock.find_by_druid(pid) 
     obj.locked.should be_nil

     Editstore::ObjectLock.unlock(pid).should be_false #can't unlock again

   end
  
end