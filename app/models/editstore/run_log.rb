module Editstore
  class RunLog < Connection
    attr_accessible :total_druids,:total_changes,:num_errors,:num_pending,:note
    def self.prune
      self.where('updated_at < ?',1.month.ago).each {|obj| obj.destroy}
    end
  end
end                 
                    
                    