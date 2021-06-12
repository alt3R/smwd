class CreatePeople < ActiveRecord::Migration[6.1]
  def change
    create_table :people do |t|
      t.string :full_name
      t.string :birthday
      t.string :username
      t.string :email
      t.string :city
      t.string :region
      t.string :country

      t.timestamps
    end
  end
end
