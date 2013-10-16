module Editstore
  class ObjectUpdate < Connection
    has_many :changes
    attr_accessible :locked
  end
end
