require 'spec_helper'

describe Editstore::ObjectLock do
  
  it "should lock an object" do
       
    pid='druid:oo000oo0001'
    
    obj=Editstore::ObjectLock.find_by_druid(pid) 
    obj.should be_nil
    
    Editstore::ObjectLock.locked?(pid).should be_false

    Editstore::ObjectLock.lock(pid).should be_true

    Editstore::ObjectLock.locked?(pid).should be_true
    
    obj=Editstore::ObjectLock.find_by_druid(pid) 
    obj.locked.should_not be_nil

    Editstore::ObjectLock.lock(pid).should be_false #can't lock again
    Editstore::ObjectLock.unlock(pid).should be_true
    
    obj.unlock.should be_true
    
    Editstore::ObjectLock.locked?(pid).should be_false
    obj.reload
    obj.locked.should be_nil
      
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