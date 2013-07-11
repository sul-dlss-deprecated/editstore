module Editstore
  require 'druid-tools'
  
  class Change < Connection
    belongs_to :state
    belongs_to :project
    attr_accessible :field,:old_value,:new_value,:operation,:client_note,:druid

    OPERATIONS=%w{create update delete}
    
    validates :field, presence: true
    validates :new_value, presence: true
    validates :project_id, presence: true, numericality: { only_integer: true }
    validates :state_id, presence: true, numericality: { only_integer: true }
    validate :valid_state_id
    validate :valid_project_id
    validate :valid_field_name
    validate :valid_druid
    validate :valid_operation

    private
    
    def valid_operation
      errors.add(:operation, "is not valid") unless OPERATIONS.include? operation.to_s
      errors.add(:old_value, "must be set for an update operation") if (self.operation.to_s == 'update' && self.old_value.blank?)
    end
    
    def valid_druid
      if !DruidTools::Druid.valid?(self.druid)
        errors.add(:druid,"is invalid")
      end
    end
    
    def valid_field_name
      if Editstore::Field.where(:name=>self.field,:project_id=>self.project_id).count == 0
        errors.add(:field, "is invalid")
      end      
    end
    
    def valid_state_id
      if !Editstore::State.exists?(self.state_id)
        errors.add(:state_id, "is invalid")
      end
    end

    def valid_project_id
      if !Editstore::Project.exists?(self.project_id)
        errors.add(:project_id, "is invalid")
      end
    end
        
  end
end
