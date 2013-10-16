require 'spec_helper'

describe Editstore::ObjectUpdate do
  
  it "should lock an object" do
       
    pid='druid:oo000oo0001'
    
    obj=Editstore::ObjectUpdate.find_by_druid(pid) 
    obj.should be_nil
    
    Editstore::ObjectUpdate.locked?(pid).should be_false

    Editstore::ObjectUpdate.lock(pid).should be_true

    Editstore::ObjectUpdate.locked?(pid).should be_true
    
    obj=Editstore::ObjectUpdate.find_by_druid(pid) 
    obj.locked.should_not be_nil

    Editstore::ObjectUpdate.lock(pid).should be_false #can't lock again
    Editstore::ObjectUpdate.unlock(pid).should be_true
    
    obj.unlock.should be_true
    
    Editstore::ObjectUpdate.locked?(pid).should be_false
    obj.reload
    obj.locked.should be_nil
      
  end

  it "should unlock an object" do

     pid='druid:oo000oo0002'

     obj=Editstore::ObjectUpdate.create(:druid=>pid,:locked=>Time.now) 
     obj.should_not be_nil

     Editstore::ObjectUpdate.locked?(pid).should be_true
     Editstore::ObjectUpdate.lock(pid).should be_false

     Editstore::ObjectUpdate.unlock(pid).should be_true

     Editstore::ObjectUpdate.locked?(pid).should be_false

     obj=Editstore::ObjectUpdate.find_by_druid(pid) 
     obj.locked.should be_nil

     Editstore::ObjectUpdate.unlock(pid).should be_false #can't unlock again

   end
  
end