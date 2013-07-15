require "spec_helper"

describe Editstore::Change do
  
  before :each do 
    EDITSTORE_PROJECT=nil if defined?(EDITSTORE_PROJECT)
    @change=Editstore::Change.new
    @change.state=Editstore::State.ready 
		@change.field='title' 
		@change.project=Editstore::Project.where(:name=>'generic').first
		@change.druid='druid:oo000oo0001'
		@change.client_note='some note' 
		@change.new_value='new value'   
  end
  
  it "require both old and new values when performing a change operation" do
       
    # start by not setting old value
		@change.operation=:update

		@change.valid?.should be_false
		@change.save.should be_false
    @change.errors.messages[:old_value].should include("can't be blank")
    
    # now set old value
    @change.old_value='old value'
		@change.valid?.should be_true  	  
		@change.save.should be_true
  
  end

  it "require a valid field" do

    # start by not setting old value
 		@change.operation=:create

		@change.field='bogus' 

 		@change.valid?.should be_false
 		@change.save.should be_false
    @change.errors.messages[:field].should include("is invalid")

    # now set a valid field
		@change.field='title' 
 		@change.valid?.should be_true  	  
 		@change.save.should be_true

  end

  it "require a valid project" do

    # start by not setting old value
 		@change.operation=:create

		@change.project_id=55

 		@change.valid?.should be_false
 		@change.save.should be_false
 		
    @change.errors.messages[:project_id].should include("is invalid")

    # now set a valid field
		@change.project=Editstore::Project.where(:name=>'generic').first 
 		@change.valid?.should be_true  	  
 		@change.save.should be_true

  end

  it "require a valid project" do

    # start by not setting old value
 		@change.operation=:create

		@change.project_id=nil
 		@change.valid?.should be_false
 		@change.save.should be_false
    @change.errors.messages[:project_id].should include("is invalid")

		@change.project_id=55 # bogus
 		@change.valid?.should be_false
 		@change.save.should be_false
    @change.errors.messages[:project_id].should include("is invalid")

    # now set a valid field
		@change.project=Editstore::Project.where(:name=>'generic').first 
 		@change.valid?.should be_true  	  
 		@change.save.should be_true

  end

  it "automatically set the default project if the constant is set" do

    EDITSTORE_PROJECT='revs'  # the name of your project in the editstore database -- this must exist in the edistore database "projects" table in both production and development to work properly

    # don't set project_id, and see if it gets set from the default value above
 		@change.operation=:create
		@change.project_id=nil
  
 		@change.valid?.should be_true
 
 		@change.project_id=Editstore::Project.where(:name=>'revs').first
 		@change.save.should be_true
    
  end
  
  it "require both old values when performing a delete operation" do
           
    # start by not setting old value
		@change.operation=:delete

		@change.valid?.should be_false
		@change.save.should be_false
    @change.errors.messages[:old_value].should include("can't be blank")
        
    # now set old value
    @change.old_value='old value'

		@change.valid?.should be_true  	  
		@change.save.should be_true
  
  end
  
end