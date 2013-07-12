namespace :editstore do

  desc "Remove completed updates"
  task :remove_complete => :environment do
    Editstore::Change.destroy_all(:state_id=>Editstore::State.complete)
  end

  desc "Remove unprocessed updates"
  task :remove_pending => :environment do
    unless Rails.env.production?
      Editstore::Change.destroy_all(:state_id=>Editstore::State.wait)
      Editstore::Change.destroy_all(:state_id=>Editstore::State.ready)    
    else
      puts "Refusing to delete since we're running under the #{Rails.env} environment. You know, for safety."
    end
  end

end