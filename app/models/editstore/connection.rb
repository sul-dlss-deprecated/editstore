module Editstore
  class Connection < ActiveRecord::Base
    self.abstract_class = true
    establish_connection "editstore_#{Rails.env}"
  end
end