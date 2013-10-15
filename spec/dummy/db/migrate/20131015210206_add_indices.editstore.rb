# This migration comes from editstore (originally 20131015205757)
class AddIndices < ActiveRecord::Migration
  def up
    if Editstore.run_migrations?
      add_index(:editstore_changes, :project_id)
      add_index(:editstore_changes, :druid)
      add_index(:editstore_changes, :state_id)
      add_index(:editstore_fields, :project_id)
      add_index(:editstore_object_updates, :druid)
    end
  end

  def down
  end
end
