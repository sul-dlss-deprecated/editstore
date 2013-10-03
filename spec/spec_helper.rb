# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.global_fixtures = :all
  config.fixture_path = "#{::Rails.root}/../../test/fixtures/editstore"
end

def generate_changes(num,druid)
  i=0
  while i < num do 
    Editstore::Change.create(:field=>'title',:project_id=>1,:druid=>druid,:new_value=>"blated #{i}",:operation=>'update',:old_value=>"boop #{i}",:state_id=>2)
    i +=1
  end
end