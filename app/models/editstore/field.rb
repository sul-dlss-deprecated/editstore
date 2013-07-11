module Editstore
  class Field < Connection
    belongs_to :project
    attr_accessible :project_id,:name
  end
end
