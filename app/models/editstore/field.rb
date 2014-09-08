module Editstore
  class Field < Connection
    belongs_to :project

    # THESE REALLY BELONG IN THE CONTROLLER and are only necessary for mass assignment
    # def field_params
    #      params.require(:field).permit(:project_id,:name)
    # end
  end
end
