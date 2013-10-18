require 'spec_helper'

module Editstore
  describe RunLog do
    
    it "should return the last completed run" do
      
      Editstore::RunLog.last_completed_run.should == nil
      last_run=Editstore::RunLog.create(:started=>Time.now - 1.month,:ended=>Time.now - 1.month + 1.day,:total_druids=>2)
      Editstore::RunLog.last_completed_run.should == last_run
      older_run=Editstore::RunLog.create(:started=>Time.now - 2.months,:ended=>Time.now - 2.months + 1.day,:total_druids=>2)
      Editstore::RunLog.last_completed_run.should == last_run
      
    end
    
    it "should return any currently running jobs" do
      
      Editstore::RunLog.currently_running.should == []
      last_run=Editstore::RunLog.create(:started=>Time.now - 1.month,:ended=>Time.now - 1.month + 1.day,:total_druids=>2)
      Editstore::RunLog.currently_running.should == []
      current_run1=Editstore::RunLog.create(:started=>Time.now - 1.day,:total_druids=>2)
      Editstore::RunLog.currently_running.should == [current_run1]
      current_run2=Editstore::RunLog.create(:started=>Time.now - 2.days,:total_druids=>2)
      Editstore::RunLog.currently_running.should == [current_run1,current_run2]
      
    end
    
    it "should prune older run logs" do
      run1=Editstore::RunLog.create(:started=>Time.now - 1.month,:ended=>Time.now - 1.month + 1.day,:total_druids=>2)
      run1.updated_at=Time.now - 2.months
      run1.save
      run2=Editstore::RunLog.create(:started=>Time.now - 1.day,:ended=>Time.now - 1.day + 1.hour,:total_druids=>2)
      run3=Editstore::RunLog.create(:started=>Time.now - 2.days,:ended=>Time.now - 1.day + 2.hours,:total_druids=>0)
      run3.updated_at=Time.now - 2.days
      run3.save
      current_run1=Editstore::RunLog.create(:started=>Time.now - 1.day,:total_druids=>2)
      Editstore::RunLog.count.should == 4
      Editstore::RunLog.prune
      Editstore::RunLog.count.should == 2     
    end
    
    it "should prune all completed run logs" do
      run1=Editstore::RunLog.create(:started=>Time.now - 1.month,:ended=>Time.now - 1.month + 1.day,:total_druids=>2)
      run1.updated_at=Time.now - 2.months
      run1.save
      run2=Editstore::RunLog.create(:started=>Time.now - 1.day,:ended=>Time.now - 1.day + 1.hour,:total_druids=>2)
      current_run1=Editstore::RunLog.create(:started=>Time.now - 1.day,:total_druids=>2)
      Editstore::RunLog.count.should == 3
      Editstore::RunLog.prune_all
      Editstore::RunLog.count.should == 1
    end

  end
end
