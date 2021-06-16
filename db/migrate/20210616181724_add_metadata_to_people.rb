class AddMetadataToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :metadata, :jsonb, null: false, default: {}
    add_index :people, :metadata, using: :gin
  end
end
