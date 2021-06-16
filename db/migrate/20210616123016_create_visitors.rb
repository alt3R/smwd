class CreateVisitors < ActiveRecord::Migration[6.1]
  def change
    create_table :visitors, id: :uuid do |t|
      t.datetime :online
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :visitors, :metadata, using: :gin
  end
end
