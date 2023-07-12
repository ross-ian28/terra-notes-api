class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :username
      t.string :password_digest
      t.boolean :logged_in, default: false
      t.boolean :incognito_mode, default: false

      t.timestamps
    end
  end
end
