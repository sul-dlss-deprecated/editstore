class CreateEditstoreProjects < ActiveRecord::Migration[4.2]

  def change
    if Editstore.run_migrations?
      @connection=Editstore::Connection.connection
      create_table :editstore_projects do |t|
        t.string :name, :null=>false
        t.string :template, :null=>false
        t.timestamps :null=>true
      end
      Editstore::Project.create(:id=>1,:name=>'Generic',:template=>'generic')
    end
  end

end
