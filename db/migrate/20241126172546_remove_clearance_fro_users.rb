class RemoveClearanceFroUsers < ActiveRecord::Migration[8.0]
  def up
    remove_index :users, :email
    remove_index :users, :confirmation_token, unique: true
    remove_index :users, :remember_token, unique: true
    change_table :users do |t|
      t.remove :encrypted_password
      t.remove :confirmation_token
      t.remove :remember_token
    end
  end
end
