class CreateEditstoreStates < ActiveRecord::Migration[4.2]
  def change
    if Editstore.run_migrations?
      @connection=Editstore::Connection.connection
      create_table :editstore_states do |t|
        t.string  :name, :null=>false
        t.timestamps :null=>true
      end
      Editstore::State.create(:id=>1,:name=>'wait')
      Editstore::State.create(:id=>2,:name=>'ready')
      Editstore::State.create(:id=>3,:name=>'in process')
      Editstore::State.create(:id=>4,:name=>'error')
      Editstore::State.create(:id=>5,:name=>'applied')
      Editstore::State.create(:id=>6,:name=>'complete')
    end
  end
end
