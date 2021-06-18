class ChangePersonIdToUuidInAnalyses < ActiveRecord::Migration[6.1]
  def up
    remove_column :analyses, :person_id
    add_column :analyses, :person_id, :uuid
  end

  def down
    remove_column :analyses, :person_id
    add_column :analyses, :person_id, :integer
  end
end
