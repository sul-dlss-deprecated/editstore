module Editstore
  class Project < Connection
     has_many :changes, :dependent => :destroy
     has_many :fields, :dependent => :destroy
     attr_accessible :name, :template
     validates :name, presence: true
     validates :template, presence: true
  end
end
