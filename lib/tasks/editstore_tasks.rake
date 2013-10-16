namespace :editstore do

  desc "Remove completed updates"
  task :remove_complete => :environment do
    Editstore::Change.destroy_all(:state_id=>Editstore::State.complete)
  end

  desc "Prune run log to remove entries over 1 month old"
  task :prune_run_log => :environment do
    Editstore::RunLog.where('updated_at < ?',1.month.ago).each {|obj| obj.destroy}
  end
  
  desc "Prune locked object tables to remove any unlocked druids"
  task :prune_locks => :environment do
    Editstore::ObjectLock.destroy_all(:locked=>nil)
  end

  desc "Remove all object locks for any druids"
  task :clear_locks => :environment do
    Editstore::ObjectLock.all_locked.each {|obj| obj.unlock}
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