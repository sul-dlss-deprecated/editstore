module Editstore
  class ObjectUpdate < Connection
    attr_accessible :locked, :druid
  
  def self.all_locked
    Editstore::ObjectUpdate.where('locked IS NOT NULL')
  end

  def self.all_unlocked
    Editstore::ObjectUpdate.where(:locked=>nil)
  end
  
  # some convenience class level methods for operating on a specific druid
  def self.lock(pid)
    status=self.find_by_druid(pid)
    if status # this druid already exists in the table
      return status.lock
    else # this druid does not exist in the table, create it and lock
       self.create(:druid=>pid,:locked=>Time.now)
       return true
    end
  end
  
  def self.unlock(pid)
   status=self.find_by_druid(pid)
   if status # this druid already exists in the table
       return status.unlock
    else
      return false # druid doesn't exist, can't unlock
    end
  end
  
  # check to see if this druid is locked
  def self.locked?(pid)
    status=self.find_by_druid(pid)
    status.nil? ? false : status.locked?
  end
    
  # object level methods for performing actions  
  def locked?
    !unlocked?
  end
  
  def unlocked?
    locked == nil
  end
        
  # lock this object
  def lock
     if unlocked?
       self.locked = Time.now
       save
       return true # lock at the current time
    else
      return false # already locked
    end
  end
    
  # unlock this object
  def unlock
    if locked?
       self.locked = nil
       save
       return true # unlock it    
    else
      return false # already unlocked
    end
  end
  
 end
end
