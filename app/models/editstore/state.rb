module Editstore
  class State < Connection
     has_many :changes
     attr_accessible :name
     validates :name, presence: true

     # these helper methods allow you to easily refer to a particular state like this, with the query cached in the object:
     # Editstore::State.wait
     # Editstore::State.ready
     
     def self.wait
       @@wait ||= self.find_by_name('wait')
     end

     def self.ready
       @@ready ||= self.find_by_name('ready')
     end

     def self.in_process
       @@in_progress ||= self.find_by_name('in process')
     end

     def self.error
       @@error ||= self.find_by_name('error')
     end
     
     def self.applied
       @@applied ||= self.find_by_name('applied')
     end

     def self.complete
       @@in_progress ||= self.find_by_name('complete')
     end
          
  end
end
