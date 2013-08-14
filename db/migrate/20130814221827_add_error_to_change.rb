class AddErrorToChange < ActiveRecord::Migration
  def change
    @connection=Editstore::Connection.connection
    add_column :editstore_changes, :error, :string
  end
end
