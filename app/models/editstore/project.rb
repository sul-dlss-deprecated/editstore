module Editstore
  class Project < Connection

     has_many :alterations, :dependent => :destroy, :foreign_key => :changes     
     has_many :fields, :dependent => :destroy
     
     # THESE REALLY BELONG IN THE CONTROLLER and are only necessary for mass assignment
      # def project_params
      #      params.require(:project).permit(:name, :template)
      # end
     
     validates :name, presence: true
     validates :template, presence: true
  end
end
