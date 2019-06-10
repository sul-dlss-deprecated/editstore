class AddLockingVersion < ActiveRecord::Migration[4.2]
  def change
    if Editstore.run_migrations?
      @connection=Editstore::Connection.connection
      add_column :editstore_object_locks, :lock_version, :string
    end
  end
end
