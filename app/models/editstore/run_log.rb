module Editstore
  class RunLog < Connection
    attr_accessible :started,:ended,:total_druids,:total_changes,:num_errors,:num_pending,:note
    def self.currently_running
      Editstore::RunLog.where(:ended=>nil).order('ended DESC')
    end
    def self.last_completed_run
      Editstore::RunLog.where('ended IS NOT NULL').order('ended DESC').limit(1).first
    end
    def self.prune
      self.where('updated_at < ?',1.day.ago).where('ended IS NULL').each {|obj| obj.destroy} # anything older than 1 day that is not marked as finished running (but must be crashed and not actually running)
      self.where('updated_at < ?',1.month.ago).each {|obj| obj.destroy} # anything older than 1 month
      self.where(:total_druids=>0).where('updated_at < ?',1.day.ago).each {|obj| obj.destroy} # anything older than 1 day with no activity
    end
    def self.prune_all
      self.where('ended IS NOT NULL').each {|obj| obj.destroy} # anything that is done
    end
  end
end                 
                    
                    