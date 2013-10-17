module Editstore
  require 'druid-tools'
  
  class Change < Connection
    belongs_to :state
    belongs_to :project
    belongs_to :object_lock, :primary_key=>:druid, :foreign_key=>:druid
    attr_accessible :field,:project_id,:old_value,:new_value,:operation,:client_note,:druid,:state_id,:error,:pending

    OPERATIONS=%w{create update delete}
    
    validates :field, presence: true
    validates :operation, presence: true
    validates :new_value, presence: true, :if => "%w{update create}.include? self.operation.to_s"
    validates :old_value, presence: true, :if => "%w{update}.include? self.operation.to_s"
    validates :project_id, presence: true, numericality: { only_integer: true }
    validates :state_id, presence: true, numericality: { only_integer: true }
    validate :valid_state_id
    validate :valid_project_id
    validate :valid_field_name
    validate :valid_druid
    validate :valid_operation
    
    before_validation :set_default_project, :if => "defined?(EDITSTORE_PROJECT) && !EDITSTORE_PROJECT.nil?" # this allows the user to set this in their project so it will set automatically for each change
    
    def self.by_project_id(project_id)
      if project_id.to_s.empty?
        scoped
      else
        where(:project_id=>project_id)
      end
    end

    def self.by_state_id(state_id)
      if state_id.to_s.empty?
        scoped
      else
        where(:state_id=>state_id)
      end
    end

    # get the latest changes to process for a specific state (defaults to ready) and an optional limit
    # if not restricted by druid, will group by druid
    def self.latest(params={})

      state_id=params[:state_id] || Editstore::State.ready.id
      limit=params[:limit]
      project_id=params[:project_id]
      druid=params[:druid]
       
      changes = scoped
      changes = changes.includes(:project)
      changes = changes.where(:state_id=>state_id)
      changes = changes.where(:project_id=>project_id) if project_id
      changes = changes.where(:druid=>druid) if druid
      changes = changes.order('created_at,id asc')
      changes = changes.limit(limit) unless limit.blank?
      druid ? changes : changes.group_by {|c| c.druid}
     
    end
    
    # get the latest list of unique druids to process for a specific state (defaults to ready) and an optional limit, return an array
    def self.latest_druids(params={})

      state_id=params[:state_id] || Editstore::State.ready.id
      limit=params[:limit]
      project_id=params[:project_id]
      
      changes = scoped
      changes = changes.includes(:project)
      changes = changes.where(:state_id=>state_id)
      changes = changes.where(:project_id=>project_id) if project_id
      changes = changes.order('editstore_changes.created_at,editstore_changes.id asc')
      changes = changes.limit(limit) unless limit.blank?
      changes.uniq.pluck(:druid)

    end
    
    private
    def valid_operation
      errors.add(:operation, "is not valid") unless OPERATIONS.include? operation.to_s  
    end
    
    # project name is case insensitive
    def set_default_project
      default_project = Editstore::Project.where('lower(name)=?',EDITSTORE_PROJECT.downcase).limit(1)
      self.project_id = default_project.first.id if (default_project.size == 1 && !self.project_id)
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
