module Editstore
  class Connection < ActiveRecord::Base
    self.abstract_class = true
    establish_connection "editstore_#{Rails.env}".parameterize.underscore.to_sym
  end
end