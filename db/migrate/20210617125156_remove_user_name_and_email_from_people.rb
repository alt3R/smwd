class RemoveUserNameAndEmailFromPeople < ActiveRecord::Migration[6.1]
  def change
    remove_column :people, :username
    remove_column :people, :email
  end
end
