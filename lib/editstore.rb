require "editstore/engine"

module Editstore
  def self.run_migrations?
    %w{development test}.include? Rails.env
  end
end
