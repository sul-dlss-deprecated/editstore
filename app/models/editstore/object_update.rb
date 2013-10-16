module Editstore
  class ObjectUpdate < Connection
    has_many :changes
    attr_accessible :locked, :druid
  end
end
