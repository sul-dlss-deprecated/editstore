class CreateObjectLock < ActiveRecord::Migration[4.2]
  def change
    if Editstore.run_migrations?
      @connection=Editstore::Connection.connection
      create_table :editstore_object_locks do |t|
        t.string :druid, :null=>false
        t.datetime :locked
        t.timestamps :null=>true
      end
    end
  end
end
