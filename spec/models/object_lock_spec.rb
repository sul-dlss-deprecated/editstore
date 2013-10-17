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
      obj=Editstore::ObjectLock.find_by_druid(Editstore::ObjectLock.get_pid(pid)) 
      obj.should be_nil # no row yet
    
      Editstore::ObjectLock.locked?(pid).should be_false # not locked

      Editstore::ObjectLock.lock(pid).should be_true # we can lock it

      Editstore::ObjectLock.locked?(pid).should be_true # it is now locked
    
      obj=Editstore::ObjectLock.find_by_druid(Editstore::ObjectLock.get_pid(pid))  # find the row
      obj.locked.should_not be_nil # it is there

      Editstore::ObjectLock.lock(pid).should be_false # can't lock again
      Editstore::ObjectLock.unlock(pid).should be_true # now unlock
      
      obj.reload # refetch the object
      
      obj.unlock.should be_false # can't unlock again
    
      Editstore::ObjectLock.locked?(pid).should be_false # it is now unlocked

      obj.reload # refetch the object
      obj.locked.should be_nil # locked column is nill

    end
    
  end

  it "should unlock an object" do

     pid='druid:oo000oo0002'

     Editstore::ObjectLock.lock(pid) 
     obj=Editstore::ObjectLock.find_by_druid(pid) # get an instance of this object      
     obj.should_not be_nil

     Editstore::ObjectLock.locked?(pid).should be_true
     Editstore::ObjectLock.lock(pid).should be_false # can't lock it again

     Editstore::ObjectLock.unlock(pid).should be_true # unlock it

     Editstore::ObjectLock.locked?(pid).should be_false # its not locked anymore

     obj=Editstore::ObjectLock.find_by_druid(pid) # fetch the object
     obj.locked.should be_nil # check the row

     Editstore::ObjectLock.unlock(pid).should be_false #can't unlock again

   end

   it "two processes cannot touch the same object lock" do

      pid='druid:oo000oo0002'

      obj=Editstore::ObjectLock.create(:druid=>pid) # manually create an unlocked row
      obj.should_not be_nil
      obj2=Editstore::ObjectLock.find_by_druid(pid) # get a second instance of this object
      obj2.should_not be_nil

      Editstore::ObjectLock.locked?(pid).should be_false # it is not locked
      Editstore::ObjectLock.lock(pid).should be_true # now lock it
      Editstore::ObjectLock.locked?(pid).should be_true # it is not locked
      obj.reload
      obj.locked?.should be_true # it is locked
                  
      expect { obj2.lock }.to raise_error # now try and lock with this second instance, which should fail due to Rails locking mechanism

      obj.reload
      obj.locked?.should be_true # it is still locked
      Editstore::ObjectLock.locked?(pid).should be_true # it is still locked

    end
  
end