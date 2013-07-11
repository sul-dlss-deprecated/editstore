module Editstore
  class Project < Connection
     has_many :changes
     has_many :fields
     attr_accessible :name, :template
     validates :name, presence: true
     validates :template, presence: true
  end
end
