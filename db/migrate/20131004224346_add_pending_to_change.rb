class AddPendingToChange < ActiveRecord::Migration[4.2]
  def change
    if Editstore.run_migrations?
      @connection=Editstore::Connection.connection
      add_column :editstore_changes, :pending, :boolean, :default=>false
    end
  end
end
