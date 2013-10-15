class CreateObjectLock < ActiveRecord::Migration
  def change
    if Editstore.run_migrations?
      @connection=Editstore::Connection.connection
      create_table :editstore_object_updates do |t|
        t.string :druid, :null=>false
        t.timestamps
      end
    end
  end
end
