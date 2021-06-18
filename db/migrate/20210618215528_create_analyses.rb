class CreateAnalyses < ActiveRecord::Migration[6.1]
  def change
    create_table :analyses, id: :uuid do |t|
      t.belongs_to :person
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end
  end
end
