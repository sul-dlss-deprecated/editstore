module Editstore
  class Field < Connection
    belongs_to :project
    #attr_accessible :project_id,:name
    def field_params
         params.require(:field).permit(:project_id,:name)
    end
  end
end
