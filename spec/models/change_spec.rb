require "spec_helper"

describe Editstore::Change, :type => :model do

  before :each do
    EDITSTORE_PROJECT=nil if defined?(EDITSTORE_PROJECT) # clear the default for each test ; we'll set it when needed for each test
    @change=Editstore::Change.new
    @change.state=Editstore::State.ready
		@change.field='title'
		@change.project=Editstore::Project.where(:name=>'generic').first
		@change.druid='druid:oo000oo0001'
		@change.client_note='some note'
		@change.new_value='new value'
  end

  it "should require both old and new values when performing a change operation" do

    # start by not setting old value
		@change.operation=:update

		expect(@change.valid?).to be_falsey
		expect(@change.save).to be_falsey
    expect(@change.errors.messages[:old_value]).to include("can't be blank")

    # now set old value
    @change.old_value='old value'
		expect(@change.valid?).to be_truthy
		expect(@change.save).to be_truthy

  end

  it "should require a valid field" do

    # start by not setting old value
 		@change.operation=:create

		@change.field='bogus'

 		expect(@change.valid?).to be_falsey
 		expect(@change.save).to be_falsey
    expect(@change.errors.messages[:field]).to include("is invalid")

    # now set a valid field
		@change.field='title'
 		expect(@change.valid?).to be_truthy
 		expect(@change.save).to be_truthy

  end

  it "should require a valid project" do

    # start by not setting old value
 		@change.operation=:create

		@change.project_id=nil
 		expect(@change.valid?).to be_falsey
 		expect(@change.save).to be_falsey
    expect(@change.errors.messages[:project_id]).to include("is invalid")

		@change.project_id=55 # bogus
 		expect(@change.valid?).to be_falsey
 		expect(@change.save).to be_falsey
    expect(@change.errors.messages[:project_id]).to include("is invalid")

    # now set a valid field
		@change.project=Editstore::Project.where(:name=>'generic').first
 		expect(@change.valid?).to be_truthy
 		expect(@change.save).to be_truthy

  end

  it "should automatically set the default project if the constant is set and the project is not set" do

    EDITSTORE_PROJECT='revs'  # the name of your project in the editstore database -- this must exist in the edistore database "projects" table in both production and development to work properly

    # don't set project_id, and see if it gets set from the default value above
 		@change.operation=:create
		@change.project_id=nil

 		expect(@change.valid?).to be_truthy

 		@change.project_id=Editstore::Project.where(:name=>'revs').first
 		expect(@change.save).to be_truthy

  end

  it "should NOT automatically set the default project if the constant is set and the project IS set manually" do

    EDITSTORE_PROJECT='revs'

    # set project_id, and make sure it doesn't get overridden
 		@change.operation=:create
		@change.project_id=Editstore::Project.where(:name=>'generic').first

 		expect(@change.valid?).to be_truthy
 		expect(@change.save).to be_truthy

    @change=Editstore::Change.last
 		@change.project_id=Editstore::Project.where(:name=>'generic').first

  end

  it "should not require an old or new value when performing a delete operation" do

    # start by not setting old value
		@change.operation=:delete
    @change.old_value=nil
    @change.new_value=nil

		expect(@change.valid?).to be_truthy
		expect(@change.save).to be_truthy

  end

  it "should get the latest updates to apply" do

    druids=%w{druid:oo000oo0001 druid:oo000oo0002}
    generate_changes(5,druids[0])
    generate_changes(3,druids[1])

    changes=Editstore::Change.latest
    expect(changes.class).to eq(Hash)
    expect(changes.size).to eq(2)

    expect(changes[druids[0]].class).to eq(Array)
    expect(changes[druids[0]].size).to eq(5)
    expect(changes[druids[1]].class).to eq(Array)
    expect(changes[druids[1]].size).to eq(3)

  end

  it "should get the latest updates to apply for a single druid" do

    druids=%w{druid:oo000oo0001 druid:oo000oo0002}
    generate_changes(5,druids[0])
    generate_changes(3,druids[1])

    changes=Editstore::Change.latest(:druid=>druids[0])
    expect(changes.size).to eq(5)
    changes.each {|change| expect(change.class).to eq(Editstore::Change)}

    changes=Editstore::Change.latest(:druid=>druids[1])
    expect(changes.size).to eq(3)
    changes.each {|change| expect(change.class).to eq(Editstore::Change)}

  end

  it "should get the latest druids to apply" do

    druids=%w{druid:oo000oo0001 druid:oo000oo0002 druid:oo000oo0003}
    druids.each {|druid| generate_changes(5,druid)}

    changes=Editstore::Change.latest_druids
    expect(changes.class).to eq(Array)
    expect(changes.size).to eq(3)

    expect(changes[0]).to eq(druids[0])
    expect(changes[1]).to eq(druids[1])
    expect(changes[2]).to eq(druids[2])

  end

  it "should get the latest druids to apply" do

    druids=%w{druid:oo000oo0001 druid:oo000oo0002 druid:oo000oo0003}
    druids.each {|druid| generate_changes(5,druid)}

    changes=Editstore::Change.latest_druids
    expect(changes.class).to eq(Array)
    expect(changes.size).to eq(3)

    expect(changes[0]).to eq(druids[0])
    expect(changes[1]).to eq(druids[1])
    expect(changes[2]).to eq(druids[2])

  end

  it "should get the latest updates to apply with a limit" do

    druids=%w{druid:oo000oo0001 druid:oo000oo0002}
    druids.each {|druid| generate_changes(5,druid)}

    changes=Editstore::Change.latest(:limit=>2)
    expect(changes.class).to eq(Hash)
    expect(changes.size).to eq(1)

    expect(changes[druids[0]].class).to eq(Array)
    expect(changes[druids[0]].size).to eq(2)

  end

  it "should get the latest druids to apply with a limit" do

    druids=%w{druid:oo000oo0001 druid:oo000oo0002 druid:oo000oo0003}
    druids.each {|druid| generate_changes(5,druid)}

    changes=Editstore::Change.latest_druids(:limit=>2)
    expect(changes.class).to eq(Array)
    expect(changes.size).to eq(2)

    expect(changes[0]).to eq(druids[0])
    expect(changes[1]).to eq(druids[1])

  end

  it "should get the latest updates to apply with a different state_id" do

    druids=%w{druid:oo000oo0001 druid:oo000oo0002}
    druids.each {|druid| generate_changes(5,druid)}

    changes=Editstore::Change.latest(:state_id=>3)
    expect(changes.class).to eq(Hash)
    expect(changes.size).to eq(0)

  end

end
