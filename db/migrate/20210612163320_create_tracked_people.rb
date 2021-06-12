class CreateTrackedPeople < ActiveRecord::Migration[6.1]
  def change
    create_table :tracked_people do |t|

      t.timestamps
    end
  end
end
