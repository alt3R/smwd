class CreatePeople < ActiveRecord::Migration[6.1]
  def change
    create_table :people, id: :uuid do |t|
      t.string :full_name
      t.datetime :birthday
      t.string :username
      t.string :email
      t.string :city
      t.string :region
      t.string :country
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :people, :metadata, using: :gin
  end
end
