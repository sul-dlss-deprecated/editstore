class AddLockingVersion < ActiveRecord::Migration
  def change
    if Editstore.run_migrations?
      @connection=Editstore::Connection.connection
      add_column :editstore_object_locks, :lock_version, :string
    end
  end
end
