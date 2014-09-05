module Editstore
  class Project < Connection
    #RAILS 4 ALIAS
     #has_many :changes, :dependent => :destroy
     has_many :alterations, :dependent => :destroy, :foreign_key => :changes
     
     has_many :fields, :dependent => :destroy
     
      #attr_accessible :name, :template
      def project_params
           params.require(:project).permit(:name, :template)
      end
     
     validates :name, presence: true
     validates :template, presence: true
  end
end
