require 'spec_helper'

describe Editstore::ObjectLock, :type => :model do
  
  it "should add the druid: prefix if missing" do
    
    pids=['druid:oo000oo0001','oo000oo0002']
    
    expect(Editstore::ObjectLock.get_pid(pids[0])).to eq('druid:oo000oo0001')
    expect(Editstore::ObjectLock.get_pid(pids[1])).to eq('druid:oo000oo0002')

  end
  
  it "should prune all unlocked druids" do
    
    unlocked_pids=['druid:oo000oo0001','druid:oo000oo0002']
    locked_pids=['druid:oo000oo003']
    unlocked_pids.each do |pid|
      expect(Editstore::ObjectLock.lock(pid)).to be_truthy
      expect(Editstore::ObjectLock.unlock(pid)).to be_truthy
    end
    locked_pids.each do |pid|
      expect(Editstore::ObjectLock.lock(pid)).to be_truthy
    end

    expect(Editstore::ObjectLock.all_unlocked.size).to eq(unlocked_pids.size)    
    expect(Editstore::ObjectLock.all_locked.size).to eq(locked_pids.size)
    
    Editstore::ObjectLock.prune_all

    expect(Editstore::ObjectLock.all_unlocked.size).to eq(0)
    expect(Editstore::ObjectLock.all_locked.size).to eq(locked_pids.size)    

  end

  it "should prune all unlocked druids older than 1 month" do
    
    unlocked_pids=['druid:oo000oo0001','druid:oo000oo0002']
    older_unlocked_pids=['druid:oo000oo0003','druid:oo000oo0004']
    locked_pids=['druid:oo000oo005']
    older_unlocked_pids.each do |pid|
      expect(Editstore::ObjectLock.lock(pid)).to be_truthy
      expect(Editstore::ObjectLock.unlock(pid)).to be_truthy
      obj=Editstore::ObjectLock.find_by_druid(Editstore::ObjectLock.get_pid(pid)) 
      obj.updated_at=Time.now - 2.months # make it older manually
      obj.save
    end
    unlocked_pids.each do |pid|
      expect(Editstore::ObjectLock.lock(pid)).to be_truthy
      expect(Editstore::ObjectLock.unlock(pid)).to be_truthy
    end
    locked_pids.each do |pid|
      expect(Editstore::ObjectLock.lock(pid)).to be_truthy
    end

    expect(Editstore::ObjectLock.all_unlocked.size).to eq(unlocked_pids.size + older_unlocked_pids.size)  
    expect(Editstore::ObjectLock.all_locked.size).to eq(locked_pids.size)
    
    Editstore::ObjectLock.prune

    expect(Editstore::ObjectLock.all_unlocked.size).to eq(unlocked_pids.size)
    expect(Editstore::ObjectLock.all_locked.size).to eq(locked_pids.size)    

  end  

  it "should unlock all locked druids" do
    
    locked_pids=['druid:oo000oo0001','druid:oo000oo0002']
    locked_pids.each do |pid|
      expect(Editstore::ObjectLock.lock(pid)).to be_truthy
    end
    expect(Editstore::ObjectLock.all_locked.size).to eq(locked_pids.size)
    
    Editstore::ObjectLock.unlock_all

    expect(Editstore::ObjectLock.all_unlocked.size).to eq(locked_pids.size)
    expect(Editstore::ObjectLock.all_locked.size).to eq(0) 

  end
  
  it "should lock an object, with or without druid: prefix" do
       
    pids=['druid:oo000oo0001','oo000oo0002']
    
    pids.each do |pid|
      obj=Editstore::ObjectLock.find_by_druid(Editstore::ObjectLock.get_pid(pid)) 
      expect(obj).to be_nil # no row yet
    
      expect(Editstore::ObjectLock.locked?(pid)).to be_falsey # not locked

      expect(Editstore::ObjectLock.lock(pid)).to be_truthy # we can lock it

      expect(Editstore::ObjectLock.locked?(pid)).to be_truthy # it is now locked
    
      obj=Editstore::ObjectLock.find_by_druid(Editstore::ObjectLock.get_pid(pid))  # find the row
      expect(obj.locked).not_to be_nil # it is there

      expect(Editstore::ObjectLock.lock(pid)).to be_falsey # can't lock again
      expect(Editstore::ObjectLock.unlock(pid)).to be_truthy # now unlock
      
      obj.reload # refetch the object
      
      expect(obj.unlock).to be_falsey # can't unlock again
    
      expect(Editstore::ObjectLock.locked?(pid)).to be_falsey # it is now unlocked

      obj.reload # refetch the object
      expect(obj.locked).to be_nil # locked column is nill

    end
    
  end

  it "should unlock an object" do

     pid='druid:oo000oo0002'

     Editstore::ObjectLock.lock(pid) 
     obj=Editstore::ObjectLock.find_by_druid(pid) # get an instance of this object      
     expect(obj).not_to be_nil

     expect(Editstore::ObjectLock.locked?(pid)).to be_truthy
     expect(Editstore::ObjectLock.lock(pid)).to be_falsey # can't lock it again

     expect(Editstore::ObjectLock.unlock(pid)).to be_truthy # unlock it

     expect(Editstore::ObjectLock.locked?(pid)).to be_falsey # its not locked anymore

     obj=Editstore::ObjectLock.find_by_druid(pid) # fetch the object
     expect(obj.locked).to be_nil # check the row

     expect(Editstore::ObjectLock.unlock(pid)).to be_falsey #can't unlock again

   end

   it "two processes cannot touch the same object lock" do

      pid='druid:oo000oo0002'

      obj=Editstore::ObjectLock.create(:druid=>pid) # manually create an unlocked row
      expect(obj).not_to be_nil
      obj2=Editstore::ObjectLock.find_by_druid(pid) # get a second instance of this object
      expect(obj2).not_to be_nil

      expect(Editstore::ObjectLock.locked?(pid)).to be_falsey # it is not locked
      expect(Editstore::ObjectLock.lock(pid)).to be_truthy # now lock it
      expect(Editstore::ObjectLock.locked?(pid)).to be_truthy # it is not locked
      obj.reload
      expect(obj.locked?).to be_truthy # it is locked
                  
      expect { obj2.lock }.to raise_error # now try and lock with this second instance, which should fail due to Rails locking mechanism

      obj.reload
      expect(obj.locked?).to be_truthy # it is still locked
      expect(Editstore::ObjectLock.locked?(pid)).to be_truthy # it is still locked

    end
  
end